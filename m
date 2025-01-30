Received: from ip197-132-198-217.pool-bba.aruba.it (ip197-132-198-217.pool-bba.aruba.it [217.198.132.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0A384D34;
	Thu, 30 Jan 2025 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.198.132.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738252982; cv=none; b=OmIzyV+OvDs/W6+yL24w8EgyR4O8PdCIyZOzLNJ6tCWFqoN0JvX6DtbKnv9aP/eMsInsS8TLvlzwvbKNHgLrOUYcpwJJLgV6rS0yJ2Kq7VPNzeuQR7nqBaMs88Y5X6o/GINXbYkF0mJDpUcuynnb7dPINtVJ3X4rrAL9MioJS3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738252982; c=relaxed/simple;
	bh=MowNCfjw9yeanYJoKb6xAQez9gEJKfIT45dksb1PMew=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=reiaSxnF/3uyoMEWaG00u48Di8iuTtCAzi+Ui2NVPevCuSQ+ZUozhAw78MDf0+ZgxrV7lZ+zgFz3ceGyaZXDD+bFNXNTkMS/GFZoNObGG1D8eevtjeWJVszn7JL0mZIw3Oqlbn5gAfDPhQXIj1sPmipF5gfqxqudTkCmIcarx9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=prosemail.net; spf=pass smtp.mailfrom=prosemail.net; dkim=pass (1024-bit key) header.d=prosemail.net header.i=@prosemail.net header.b=f7eEcEpn; arc=none smtp.client-ip=217.198.132.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=prosemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=prosemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=prosemail.net header.i=@prosemail.net header.b="f7eEcEpn"
Received: by ip197-132-198-217.pool-bba.aruba.it (prosemail) with ESMTPSA id F1408640E7E;
	Thu, 30 Jan 2025 16:55:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prosemail.net;
	s=mail; t=1738252508;
	bh=c+Vw0dNes77GKKCSeCYY15Ec8wGddFy4gDnlYQMwQXQ=;
	h=Date:To:Cc:From:Subject;
	b=f7eEcEpn3TNg9c3dMxedGfb3J5JEgZ80zvyxYG5oiX92RGSah+wIwuM9ETjTIZb28
	 EWi2yBoE3R2VCZKanhVleisw/2iooqDK0tVLetw4gbTg4mKtKUbmJVE+VCtbrqQ5FC
	 nw1hMIXdLsKUM7hQBI0mMfs3WdXL4uUcp6yWQY2E=
Message-ID: <9bec6888-58f2-49f8-86d6-bd7342af5973@prosemail.net>
Date: Thu, 30 Jan 2025 16:54:41 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Scall <scall@prosemail.net>
Subject: drivers/crypto/ccp/ccp-ops.c:913:1: error: the frame size of 1032
 bytes is larger than 1024 bytes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Trying to build Linux 6.12.11 with GCC 14.2.1 and KCFLAGS="-O3":

[...]
drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_aes_gcm_cmd':
drivers/crypto/ccp/ccp-ops.c:913:1: error: the frame size of 1032 bytes 
is larger than 1024 bytes [-Werror=frame-larger-than=]
   913 | }
       | ^
[...]
