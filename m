Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=134.76.10.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794563940;
	b=n3U5/MfMWb9ol/EB/5vN4eARKqC0Y3E/f7B9jV5vIurvQxZhsJK7TZZn2C99+tWgP0lh
	 IZhjIBkCazrL/9iMks1XHol9K763r/0v72QFkq1Eh4NUh6yB8ISNX3AHUaemp2k4cDHUW
	 t4f0T/i67pnBuIV4j6Ow8MUs5Zkg05C9Qz+DkC7sXPtxhI+HVOM9ORW8V6/t44GnEKfYB
	 oOnYRp7c8Fqqq6PXPwfjo5rYlAPpysyn2DWe/KKW059TuriAlt0GfZdcE+8Q5yzpFv2c+
	 B0NbUlwVKDnsP4Qol9zb5x+dtNJvyTnwY24mB9NcVA4qBbir4Tl6L4fYxVewJl3QwkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794563940;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
	 X-Virus-Scanned:X-Spam-Level;
	bh=Z8ldHOW7Jh2F6tB55n2yK83TrHX8HOmq++gHNOoKpbM=;
	b=43jvoaCv874uqU1x8uT5PTuQ2i9fWN7cm4lG3IIiM/3VmiK3rQH1kdfuzRwVf3Y/fdz4
	 OqkOsiM1kOCA/mKorLvpuKElMJJrAkl9SaYYRfodjFc2TDfs2OpSNHCviQ9KwomWh/n30
	 v2J9pYdCjROAR8vDj5N9H59ubl/mbXBIclstvgdgXakdRJsVDTczow1d6qhP820ewrlSP
	 hwDFYsjoNdaqajCH/5BdUO9ogJ8NxIfhDi1BpuN59j5rCEBYKiqtdZGpLytwAQCZAapc1
	 zl7AjJMjtO+BupO1sOoOLoOM4JUTjxk5oOQicCEyww8vQA23JeoRf4xir5Q3hPx0jQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cispa.de;
	spf=pass smtp.mailfrom=cispa.de;
	dkim=pass header.d=cispa.de header.i=@cispa.de header.a=rsa-sha256 header.s=2023-rsa header.b=ceKLPTAx;
	arc=none smtp.remote-ip=134.76.10.21
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AD9606A32A;
	Fri, 13 Nov 2026 09:58:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09AD9606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cispa.de header.i=@cispa.de header.a=rsa-sha256 header.s=2023-rsa header.b=ceKLPTAx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:CC:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Z8ldHOW7Jh2F6tB55n2yK83TrHX8HOmq++gHNOoKpbM=; b=ceKLPTAxriYEtBfMFr+ly6Q9CQ
	P7Avfhi9L1WtV7iv0ZXw2uSAKcG/AkXEnFYRsbvk0MpG4pHcEHWum1FVYqFNjzKgXsOQSikcpGiBO
	dDVHnvr8vO0REmUjiVDRCSNOfFHVLU5Av7CkF/e7FjYQoLxF3Xek9kTchzK2KRJGZlZMrL6/lj2Ws
	uLLpqbt2yZpn2apgBP0QUftPswkQJp1K+qdYAXzR5woacDoNRYAYNjAa+a2K9YuukgW07FlHITDX/
	MydLuvaIxObpAccFLfHYOh5P4UHktu/P43wYPIm5Zd1h15F9L8jrhVfrb4QcuCJ7dNhRYSBbPSQML
	8vi8ruDg==;
Received: from mailer.gwdg.de ([134.76.10.26]:53240)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <florian.bauckholt@cispa.de>)
	id 1xRo3R-005Tb9-1b;
	Fri, 13 Nov 2026 10:58:45 +0100
Received: from mbx19-sub-11.um.gwdg.de ([10.108.142.88] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	(GWDG Mailer)
	(envelope-from <florian.bauckholt@cispa.de>)
	id 1xRo3S-000Y5M-0Q;
	Fri, 13 Nov 2026 10:58:45 +0100
Received: from [192.168.0.168] (10.250.9.199) by mbx19-sub-11.um.gwdg.de
 (10.108.142.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Fri, 13 Nov
 2026 10:58:45 +0100
Message-ID: <473700a3-f5d7-4a7a-b89a-12c51adcc3df@cispa.de>
Date: Fri, 13 Nov 2026 10:58:44 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ecdsa - Reject non-DER X9.62 signatures
To: Stefan Berger <stefanb@linux.ibm.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Jarkko Sakkinen <jarkko@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20261112-ecdsa-x962-der-v1-1-36b24c5f5e11@cispa.de>
 <e852580d-9e18-4733-a431-2db8c5f9c2a3@linux.ibm.com>
 <d3a49bde-769f-48a9-ab1b-0374d3d4753e@linux.ibm.com>
Content-Language: en-US
From: Florian Bauckholt <florian.bauckholt@cispa.de>
In-Reply-To: <d3a49bde-769f-48a9-ab1b-0374d3d4753e@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MBX19-FMZ-07.um.gwdg.de (10.108.142.66) To
 mbx19-sub-11.um.gwdg.de (10.108.142.88)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -

Hi Stefan,

thanks for testing.

On 11/13/26 00:38, Stefan Berger wrote:
> On 11/12/26 12:06 PM, Stefan Berger wrote:
>> I have a user-space test suite here:
>> https://github.com/stefanberger/eckey-testing
>>
>> It tries to load openssl-generated self-signed certs into the kernel
>> and this fails now:
>>
>> $ ./test-ecc-kernel-keys.sh

I can reproduce this with your script. It fails without the
KEYCTL_PKEY_VERIFY patch and passes with it.

>>> This is a behaviour change for every user of the x962 template (X.509
> 
> I would say a 'potential but unlikely behaviour change' because if you
> signed with a tool (e.g., OpenSSL) that created properly (DER-)formatted
> signatures in X.509 certificates, then those signatures still verify
> with your patch applied. I would assume that most people signed with
> such a tool. In your patch you seem to add more tests for proper DER
> formatting that all existing x.509 certs and signatures should meet, right?
>

Yes, this only changes behaviour for non-conforming signatures. Anything
generated by OpenSSL behaves the same. I'll change the wording to be
explicit about this for v2.

The existing testmgr vectors covered only valid DER encodings and this
patch adds new ones for the BER edge cases.

>>> certificates, module and IMA signatures, KEYCTL_PKEY_VERIFY): signatures
>>> that are valid ECDSA signatures but are not DER-encoded used to verify
>>> and are now rejected with -EINVAL. The p1363 template is not affected.
> 
> What breaks the signature verification test in my test suite currently
> was pointed out by AI. For signature verifications using the
> KEYCTL_PKEY_VERIFY interface, it currently would pass along an input
> size of 72 bytes for a secp256r1 signature, which is the max. size, but
> this does not always correspond to the application provided signature
> size, which may for example be just 71 bytes.
> -               params->out_len = info.max_sig_size;
> +               params->in2_len = uparams.in2_len;

Yes, sorry, maybe I should have mentioned this in the commit message.
The notes below the --- link to this exact fix:

https://lore.kernel.org/r/20261111-keyctl-pkey-fixes-v1-1-934ebaa267a7@cispa.de

The AI review in the thread also ran the patch without the keyctl fix.

I'll move this dependency to the commit message for v2, or wait until
the keyctl fix is in mainline.

Thanks!
Florian
