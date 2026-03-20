Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA8B388373
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 09:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773999762; cv=none; b=NqQEc6ePakoYnGyaFGEUY+o1uK4LsNE6NlquELnBFbsh/sw5FDpy0WmKEaNcazq6dvgW7YNbgC5bVUS5P4TiB5B/QipAYDteEMG1iv5Z+83AaSg6RanNVBPoDtB9X+S0dqYm7jDSmkammN0X8sVHCMBDgvqNVLuaBv95a1SJHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773999762; c=relaxed/simple;
	bh=9rjqdbqaIHLenS9j654QKokylhRvv9+LrREq7l6+yY0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=O5jWPHta4eZq9+pFONvWHvU6ckmUwqWpWK8HgOJmJXXqopep0TJc0yrvmie1iiPVVMO+MpjqHYxhVg4lkcM62oYwCiDo15oypqhzXQRWOhTm7YYHr0PACreJ8H5pDaZ2M6qeDvYJOz9NnhD5lmzryshWizCoe4QcUcNthMlNil0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=Yk5uBF8N; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="Yk5uBF8N"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 7BF791A2F04
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 09:42:31 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 4DBAB600E0
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 09:42:31 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A745310450B62
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 10:42:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1773999750; h=from:subject:date:message-id:to:mime-version:content-type:
	 content-transfer-encoding:content-language;
	bh=e3G34KfdWx/wIiaQ2xvPo5U+D4jfGltTvsQWltOMVII=;
	b=Yk5uBF8NTN84t+1rBPcc1Q5W1aenL7FD6UaxQoMzwvQxWAUXZrBFqXJH9lYEXRl7yNC8sS
	e9wTQQcvOrjKh0eJvNw49bIvmvHlXiwcotyoPy1GcO1t6Zhf3XTLlD8wYH5aximEGl/QzR
	6B0sAtn9Q+UxTtfUfhXmpNqu/XQMh0s7oVi1Gm71an8o31WllTJZSl1GqwC2nh7Jhhx3Fl
	BRg7omSWpUnYVXBMslJ1rvVU2PwFsRzsW351sJ+II2oe6UUZ4egRIJSViBszOYuYb1g3Ut
	E5Qi7dIIYRy0xBYo+RQymVID1bbBYCfSeqwBy7QpwanmtF0x3JxSfHKo2hpsXg==
Message-ID: <4f93481a-a0e5-4a9f-8aae-00d3189ccc58@bootlin.com>
Date: Fri, 20 Mar 2026 10:42:30 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-crypto@vger.kernel.org
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: Need some clarification about CRYPTO_AHASH_ALG_BLOCK_ONLY
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hello,

I have stumbled across a flag defined in include/crypto/internal/hash.h : 
CRYPTO_AHASH_ALG_BLOCK_ONLY.
To get more information about what exact behavior this flag do, I read the 
crypto_ahash_update function.
 From the looks of it, it seems that the API will call the tfm update if there 
is enough bytes (and by enough I mean at least a block size), from the internal 
buffer and the incoming ahash_request.
In this case, I find the BLOCK_ONLY naming a bit of a misnomer, since it only 
guarantee you than req->nbytes will be at least a block size.
I initially though that the API would only give a request that are a multiple of 
the block size.

This flag, among others, are relatively recent.
I think adding documentation about these flags would be a great idea.

Regards,
Paul.

-- 
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

