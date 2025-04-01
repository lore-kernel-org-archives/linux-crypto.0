Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC9F1EB1B2
	for <linux-crypto@vger.kernel.org>; Tue,  1 Apr 2025 09:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743498769; cv=none; b=UpNJKgUImawq2g7bZey6zOpCMG43vICfdJxG7/7C1CdrG3qcMdB9mhWxkUdNAZVj2ftMEw1ctEddSc0xLz6b3tT3SF+DWIjEWUPx3prLqBTnHA1RP7fs2C44edlQb/yJJ1uSyCJNWbt61ouA0JoJ1nOm3SyzKmlqODbc1lk2OgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743498769; c=relaxed/simple;
	bh=0fHtrb+LNAR4tza3J9dxsP5nJNvCJVjEXqPv7hoLzuo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=YyD7UWlaLrpf8jUoM0Gx6shNZELEelB/fonuX9/TMrLtZhfiDHhLidyPwBBMk2YmXdg23eJFNJ4HQt2towj+Q216gH2CelarfUC8FAW6dDQrTGNn8bJ+W4vOID0mCXElYVOcvdgd5hwPwAN3mPoAinbdM1lDR6DC3ytT1xfIzXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [192.168.10.87] (unknown [39.110.247.193])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id 6DBE03F1AB
	for <linux-crypto@vger.kernel.org>; Tue,  1 Apr 2025 11:04:04 +0200 (CEST)
Message-ID: <967683fe-006f-4966-b458-685a6f0ba2af@hogyros.de>
Date: Tue, 1 Apr 2025 18:03:59 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
Subject: ahash and state kept in hardware
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

the keyslot discussion reminded me of a bit of an annoyance I have in 
the implementation of an SHA offload device: the import/export functions 
are synchronous, but my state is kept in the device.

I've sort of worked around this by submitting an extra "please dump 
state" request after each submitted asynchronous request, so export can 
take the last dump instead of requesting a new one.

This works basically because the hardware interface is locked around 
submission, so I can atomically enqueue the export after the update 
operation, followed by an internal "checkpoint" operation that generates 
an interrupt which signals completion of the update operation -- and as 
long as export is only called on an idle req, this is reasonably safe.

It's not great, however, because the additional requests I need to 
generate for this have an overhead, and because of the assumed state of 
the req.

Ideally, I'd keep the entire state in hardware (that is where a kind of 
keyslots come in, although I don't need to expose these to userspace), 
and all commands would be submitted asynchronously. The goal would be to 
export hash state only when explicitly requested by the user, or when 
running out of device memory for state vectors.

The main obstacle I can see here is ahash_save_req, which uses an 
export/import pair to copy the state vector between requests and expects 
this to be instantaneous -- the netlink interface is asynchronous 
anyway, so it could be implemented as a normal async request the same 
way init/update/finish is handled.

Would it make sense to

  - have a dedicated asynchronous "save" or "copy" operation (possibly 
with a default implementation), and
  - make export and import operations asynchronous and queueable?

Slightly related: is there a way to ask for the output of an ahash to be 
DMA accessible (right now I use a separate buffer, and copy from an 
interrupt)?

    Simon
