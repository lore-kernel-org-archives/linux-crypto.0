Received: from smtpx011.webglobe.com (smtpx011-96.webglobe.com [62.109.151.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B312DC323
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 18:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.109.151.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771527321; cv=none; b=BS5cScGXcmSbL17xEKf3w/05WHgvro0giX2SfXMBGjR1vm463M+WegXbInQY4I60EOIJbZk+0+Y3qFp+/F4QihzC7PVm864z0SiraaaKNN6zwPtkcaa59jj5p3H2Ac+f6cHlm8kDF+5mmqIas53sJ/ZRsgUyrZstqi9QS2ss7DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771527321; c=relaxed/simple;
	bh=w47ySeYFZhdelnIq6mnnxsZ1sNJ/yfbrK1oIhDGamyc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=sGmvBLcGx9fqT3wk3XW6L+SoyxE967VmGa9nkmPzjs76PX4IeZNF+nhhCXLWkb4hkdABgBGGwONQIEEj3OJuQjGST9u+rhhCdcs83GHg0jJYv71t9zTlcXKr7UqrGegNRFbEWT/nTe+gHr7Mhw3WmvPGqZoBcUgPnir2qdxbw54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mazyland.cz; spf=none smtp.mailfrom=mazyland.cz; dkim=pass (1024-bit key) header.d=mazyland.cz header.i=@mazyland.cz header.b=SX/KxweI; arc=none smtp.client-ip=62.109.151.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mazyland.cz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mazyland.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mazyland.cz header.i=@mazyland.cz header.b="SX/KxweI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mazyland.cz
	; s=default; h=Content-Transfer-Encoding:Content-Type:Subject:From:Cc:To:
	MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Hlw4actWgdvCHvfkjZHH3RYK1VHGXWJlfYYztHqVA+Q=; b=SX/KxweIHjOxKVW+gTuYJwFkxP
	P9DoVQS5j7WMa5s0wjTv85a8tmmmedZac/YqY+JPCzBN9usI8gbjE4GfSbrP8VjNMNg20BkXFne7V
	R0ZUom4wKsiK5n10KkFZTbkIVZpd18555KKh/ruMHigd9U6prFd44begSjeHfk5qmGTI=;
Received: from [62.109.151.60] (helo=mailproxy10.webglobe.com)
	by smtpx011.webglobe.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <milan@mazyland.cz>)
	id 1vt95Z-00C3ST-Dh; Thu, 19 Feb 2026 19:49:25 +0100
Received: from 85-70-151-113.rcd.o2.cz ([85.70.151.113] helo=[192.168.2.14])
	by mailproxy10.webglobe.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <milan@mazyland.cz>)
	id 1vt95Z-009G5d-57; Thu, 19 Feb 2026 19:49:25 +0100
Message-ID: <a6d69da9-2979-4b51-8560-2a554b9f7dd1@mazyland.cz>
Date: Thu, 19 Feb 2026 19:49:18 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Milan Broz <milan@mazyland.cz>
Subject: Using aes-generic, kind-of regression in 7.0
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Id: milan@mazyland.cz
X-Mailuser-Id: 923906

Hi Eric,

we see failures in cryptsetup testsuite, caused by commit
a2484474272ef98d9580d8c610b0f7c6ed2f146c "crypto: aes - Replace aes-generic with wrapper around lib"

TBH I am not sure this is a regression, as the internal naming (like aes-generic) was not supposed
to be used in userspace. Unfortunately, it happened by (perhaps my) mistake with introducing "capi" syntax in dm-crypt.

For example this command
   dmsetup create test --table "0 8 crypt capi:xts(ecb(aes-generic))-plain64 7c0dc5dfd0c9191381d92e6ebb3b29e7f0dba53b0de132ae23f5726727173540 0 /dev/sdb 0"

now fails. Replacing "aes-generic" with "aes-lib" obviously works.

Cryptsetup tests use aes-generic to simulate some of these "capi" fu***ups.
(LUKS now explicitly disables using that dash driver syntax.)

I can fix cryptsetup testsuite, but I am not sure if anyone actually use this (specifically to avoid using aes-ni or some accelerated crypto drivers).

I am not sure what to do with that... *-generic name could be used as some defaults.

Is it worth to introduce some compat mapping, or just document this was just not a supported thing?

Thanks,
Milan

