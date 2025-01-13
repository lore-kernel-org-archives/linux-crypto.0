Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE5923ED64
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jan 2025 09:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736760892; cv=none; b=Bg9X9Nrc0sfkcz/FOCiEkzNcOAMoPuqSlNWMhJTaVeSQj6Iuwd2aHsiC1MRWp3sHvs8no8jLM+ZBbvlOFKIiH7Jys2YRotkv3kmUivB7E/HK2996AqZAmontOmqJDPV15dPTtosRW757Gw/ExSALM6Rm60hRwfShvxbVLptmHME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736760892; c=relaxed/simple;
	bh=WTvxv5XK+lseEg6Cz4O5nRQNoyp/K2+Kf/w8JlvKDvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IdmW+TczTafmEescdRl2FJTu+9k4MJuaWWeMDM8j7G2ZhKz60vVK/XRZeyCR08QOafGA9U3ZDar5DTioyCf4wS5KH1Cygu0tFAkPd6xXZSvdRPwrlIvaUude96w1CL9ZHV73r0ySb3l0pPq2X/xSjJtVz/+quCqC5qmzCVE6CtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g9Vxlyqy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LyuZbMIr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jvNonc/v; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=w0EGYnFX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g9Vxlyqy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LyuZbMIr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jvNonc/v";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="w0EGYnFX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EF8C61F37E;
	Mon, 13 Jan 2025 09:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736760889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJtItRWMa1Ocrqf4q6LRj+97hgRU63+mrv38GHTutCY=;
	b=g9Vxlyqyn5Dk9Fl0Nl8OnpcYRk7zqs5pCl4RFM3ayPTJSo8A5JqzA8x51rL9p5hY6w+mm1
	zjW11q9N8QX44zx+OAAXdLf4mkeZ77rKteG6yGVWAhf65q/qyQbVS74X4tfafEQrG9EekW
	6K88wdAnNvWPAnAWwL2BysSMadrL1Vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736760889;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJtItRWMa1Ocrqf4q6LRj+97hgRU63+mrv38GHTutCY=;
	b=LyuZbMIrSKfKuT51vGOTdqD1l6AYSRwrbbDPKx6+K2iOVrdnqAn+qa8BK3PCwlZ11a11HV
	qAc3Y1DO6NB3iqDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="jvNonc/v";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=w0EGYnFX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736760888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJtItRWMa1Ocrqf4q6LRj+97hgRU63+mrv38GHTutCY=;
	b=jvNonc/vkj7DD2vcvqNnmqnhzPg6npD48SfzzkSw8oRbr/EU+DJnpYSW5xXXbPdz8uExC6
	wYDwYU2k/j+ysc7DGPMydF6KDqYyK0vCyMT1OKy09f70lx5O7wASOqTNFDxysujIGCSMVw
	cQVbX0yEKxEV3R+kEhdK6P0WkZzUdIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736760888;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJtItRWMa1Ocrqf4q6LRj+97hgRU63+mrv38GHTutCY=;
	b=w0EGYnFX2qAx5BBm5RQmuT0+gllES0oAlE35Jyq80+OOoYMjXoZMdzIuwQKY+aNE9Y2rHC
	nMfAnBVj3d5Eh4Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D708B13310;
	Mon, 13 Jan 2025 09:34:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MXIMNDjehGeIWAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 09:34:48 +0000
Message-ID: <f5772112-abdd-4b20-a505-3ce71fe8d7ba@suse.de>
Date: Mon, 13 Jan 2025 10:34:48 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] nvmet-tcp: support secure channel concatenation
To: Keith Busch <kbusch@kernel.org>
Cc: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org,
 Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20241203110238.128630-1-hare@kernel.org>
 <20241203110238.128630-11-hare@kernel.org> <Z36o7IqZnwkuckwF@kbusch-mbp>
 <69208b76-71ac-464f-bdb9-50c9c5558ac6@suse.de> <Z4REeAUzXi3z2jeb@kbusch-mbp>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <Z4REeAUzXi3z2jeb@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF8C61F37E
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 1/12/25 23:38, Keith Busch wrote:
> On Thu, Jan 09, 2025 at 08:33:51AM +0100, Hannes Reinecke wrote:
>> On 1/8/25 17:33, Keith Busch wrote:
>>> On Tue, Dec 03, 2024 at 12:02:37PM +0100, Hannes Reinecke wrote:
>>>> Evaluate the SC_C flag during DH-CHAP-HMAC negotiation and insert
>>>> the generated PSK once negotiation has finished.
>>>
>>> ...
>>>
>>>> @@ -251,7 +267,7 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
>>>>    	uuid_copy(&ctrl->hostid, &d->hostid);
>>>> -	dhchap_status = nvmet_setup_auth(ctrl);
>>>> +	dhchap_status = nvmet_setup_auth(ctrl, req);
>>>>    	if (dhchap_status) {
>>>>    		pr_err("Failed to setup authentication, dhchap status %u\n",
>>>>    		       dhchap_status);
>>>> @@ -269,12 +285,13 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
>>>>    		goto out;
>>>>    	}
>>>
>>> This one had some merge conflicts after applying the pci endpoint
>>> series from Damien. I tried to resolve it, the result is here:
>>>
>>>     https://git.infradead.org/?p=nvme.git;a=commitdiff;h=11cb42c0f4f4450b325e38c8f0f7d77f5e1a0eb0
>>>
>>> The main conflict was from moving the nvmet_setup_auth() call from
>>> nvmet_execute_admin_connect() to nvmet_alloc_ctrl().
>>
>> I'll give it a spin and check how it holds up.
> 
> Sorry, I had to drop this from 6.14 for now. The build bot tagged us
> with the following error. It looks easy enough to fix but I can't do it
> over the weekened before the first merge window pull :)
> 
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
> branch HEAD: f28201922a357663d4a2a258e024481e19269c2c  Merge branch 'for-6.14/block' into for-next
> 
> Error/Warning (recently discovered and may have been fixed):
> 
>      https://lore.kernel.org/oe-kbuild-all/202501120730.Nix2qru3-lkp@intel.com
> 
>      auth.c:(.text+0x986): undefined reference to `nvme_tls_psk_refresh'
>      csky-linux-ld: auth.c:(.text+0xa00): undefined reference to `nvme_tls_psk_refresh'
> 
> Error/Warning ids grouped by kconfigs:
> 
> recent_errors
> `-- csky-randconfig-001-20250112
>      |-- auth.c:(.text):undefined-reference-to-nvme_tls_psk_refresh
>      `-- csky-linux-ld:auth.c:(.text):undefined-reference-to-nvme_tls_psk_refresh

Don't you also love kbuild robot ...

Fix is quite easy:

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index 486afe598184..10e453b2436e 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -109,7 +109,7 @@ config NVME_HOST_AUTH
         bool "NVMe over Fabrics In-Band Authentication in host side"
         depends on NVME_CORE
         select NVME_AUTH
-       select NVME_KEYRING if NVME_TCP_TLS
+       select NVME_KEYRING
         help
           This provides support for NVMe over Fabrics In-Band 
Authentication in
           host side.


which obviously needs to be folded into patch 'nvme-tcp: request
secure channel concatenation' (the cited patch is a red herring;
it only exposes the issue, but the issue got introduced with the
patch to nvme-tcp).

Can you fold it in or shall I resubmit?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
