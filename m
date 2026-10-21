Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792567520;
	b=oCsdeWscRW7FtzzvbVSyAZbEVhot2qKZvcqnOGIfgis1OELtxzlOLPH7pvxWQZAqVEz+
	 R0COPguS92IvPtgw4b7UZScGc7VdTfC38SXzGr81S30UbpEsFIn7wh/RT1bnjTmq2i41Q
	 Y2Cr3XHLXYwg6Is0+7Rokcf5JisDYQypADV2wZsAv2FMLDoJBeZJtJ7HUmN41oPtnR807
	 y8Bj3pfYytT1AGAK+GeEDMGIcdMT8cf90ZW0BaxV4BQEiG3pVk1krW+CjGmIFg+vuyL5Z
	 VUEwAqG9fdr1nJdWOKM9R4KkJMSm5Lc3cf/yzjsw+CcbYcmIBv77sOL0WBHF6QW10rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792567520;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=XTUtpD9OS/QfLklLd9mJ88yeq0jZYM/qvZwXsuOeGAI=;
	b=B++u4UGT54lA3+iK++8h7kkEiS6lCpKEZadQyggo6+P8/A1sXaZFBcb1pLqQMyAmI9og
	 lhptcxTBBLVb7LzS1NzUnxgf8blL9ta3Y9sJTX6ljyeYWdtPx1nfert87Vah3y6hiyE+2
	 108nNVJleaClNCNc2Y9ZCgUTD0FALawLyaAp22EDVh5CU5hNr6cUePQ0KostvppLa4eIV
	 6NRD+CxKz6eOx9ZiOs5o/n0WKW+YT+KrzIL+7HhULQhfDjvVLiy00DOX/A2SPysT2oN0+
	 kGAQx03z75z3KtzhTD8Au7nueUiG28hK46f9BF2wFXP1yrBeUmLO5VMiekTdDsGTYew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=B+BQfzdq;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=K0jeqQBh;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EEE606A31C
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 07:25:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15EEE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=B+BQfzdq;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=K0jeqQBh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792567519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XTUtpD9OS/QfLklLd9mJ88yeq0jZYM/qvZwXsuOeGAI=;
	b=B+BQfzdqzYZz/MNrdOUNa5ByveMuSucA98HKbw3nL33WCciUO/xBelescU2YoIvXbMKWom
	s1hJussCL+5fevljRoSgmByKs1ykWL7b5zuY9aLAMImpWTvUMFxLVL8ydPCmGs8q1sPW2s
	nyZ5PoIFXMdJ4nWVazsGMylIc8Y/e+s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-p_sCH_sTPUu8CC_NxYR3LA-1; Wed, 21 Oct 2026 07:25:17 +0000
X-MC-Unique: p_sCH_sTPUu8CC_NxYR3LA-1
X-Mimecast-MFC-AGG-ID: p_sCH_sTPUu8CC_NxYR3LA_1792567516
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1d7c3b38eso3720335e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 00:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792567516; x=1793172316; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XTUtpD9OS/QfLklLd9mJ88yeq0jZYM/qvZwXsuOeGAI=;
        b=K0jeqQBhFzXFeLT0kvtMts+eIwbE1jWqaY1diAJVyKhBZ3Ulr7H3Wt4ROHiRfzxo7+
         H8omdqQNs/dvExRsfM2KHxBWOsSq1tZxasTbLiB1JTGgjEIf6+D3oGEfAc1z/j8rKa0f
         dX7sxtbPFjBDKLPWYhJqvrQNO49Bux1SR8gMYmZgDUIhZKUzBYeD6hDDaGPqdWYp03/D
         pCOYV2pZkqY3+gitYEpFnLqM3YTZTOegjAscfaakkD67sL2aQRE+TDLgrYxO2xD8hbmi
         GM3B64l/jVLfaQHJE55MKkg5ApfodnF2V8nWwC+qZxE9BIvpEoEXrVXpELODrg0F9YUa
         nV3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792567516; x=1793172316;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XTUtpD9OS/QfLklLd9mJ88yeq0jZYM/qvZwXsuOeGAI=;
        b=Sgm/ob9qVPxEKQ8KQiVLFmh1PpRGa6PWNEm99FwFUxYu1pj2gXFu8PsXL/JTvANSfX
         59IEaH2nwDiTTxBL4Nby79iDoqNMrC8UTBppYYRPFks/y7coGQN67LNQRbppqokt0jbx
         FuX06pYHSbZO5Lnnwox7BQa+IJJJdJpRiVuXn1Bn8lYzr7XgdGmYKP9OS3R+JeDJYkgR
         KvkTa6aclOFb2+hvqtrJw43KP0V6XnSahfpSvaBBCvGNuVL5NjUQte5lRSQy3RPl2hHM
         +EEvfFM/S0+PHefnR6sdqdaaMNpBZtBGPFZ1UCxESX7CTHb6+BO/xLLRfzNw34+JRYqK
         ZFOA==
X-Gm-Message-State: AFq9FYKl/gVO+E1yXl6AGzW1P8ia/d0lTGpGTIK9wq4LGQ+NPepzD+8W
	nudsNoOvDmJPUf6SIslTmbKKpfkhgdPGKioR5ttecfUMjvzDddq351Xy7uxvB0Mfb+BNpMJKzeH
	yfw1kau2g0ifkaIkGUzcKvUwR79olgD3lffGx9hZWVy1rkL91pwb8aXI89zMWCSTBZoNv1Xoxaw
	==
X-Gm-Gg: AYBFou024xqgGh5BjA9LcPia5lmZzSvyi7jEAYv72ypjGDOJdjJry2ppWYD3nhLhil7
	ObHJSVyDGdPIQ2T2ihgq+DjGbliBXDzxnVV7DGyAj1JYrFP47mSlTy32ag9IQaR1eKCy+W6NJcb
	5559nBI+wYWwR89S5vnDumLyY9r0dGKNGTOyo70WUnpWGpt6Aoqq3CVfCTTFHT4mF4dJB6Gr64q
	puZF2+Toweuf11ijbfvotrBGsgE7vrPqxw6Mg0PTs8WzCrwnvAW9uowbF8q3Hf030rAhUe7W9+M
	7Pp+4Q12eqmgCGBOQyPjkmmsi5I95jn3qQNQXy5zpsI5DZeG7z35fjxGYlAsmO050lOUSPrc
X-Received: by 2002:a05:600c:c4a7:b0:4a1:d41a:afc2 with SMTP id 5b1f17b1804b1-4a1fd8cb7aemr22317295e9.3.1792567516304;
        Wed, 21 Oct 2026 00:25:16 -0700 (PDT)
X-Received: by 2002:a05:600c:c4a7:b0:4a1:d41a:afc2 with SMTP id 5b1f17b1804b1-4a1fd8cb7aemr22316935e9.3.1792567515946;
        Wed, 21 Oct 2026 00:25:15 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.113.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fb80f05bsm55321055e9.3.2026.10.21.00.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 00:25:15 -0700 (PDT)
Message-ID: <acc91656-7976-4a94-9b2e-68fbfa542114@redhat.com>
Date: Wed, 21 Oct 2026 09:25:14 +0200
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
Subject: Re: Enabling Sashiko replies to linux-crypto?
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <20261020215744.GF699485@google.com>
 <d3dc7e74-0189-4aa6-b23d-0fa8ad75e059@redhat.com>
 <20261021065459.GD31908@sol>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20261021065459.GD31908@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/10/2026 08.54, Eric Biggers wrote:
> On Wed, Oct 21, 2026 at 08:18:18AM +0200, Thomas Huth wrote:
>> On 20/10/2026 23.57, Eric Biggers wrote:
>>> Currently, Sashiko is configured (in
>>> https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml)
>>> to monitor linux-crypto for patches, but not to send emails to it.
>>>
>>> Would there be any objections to me opening a pull request that changes
>>> it to the same setting that I set the fscrypt and fsverity lists to?
>>>
>>>       ["linux-crypto@vger.kernel.org"]
>>>       reply_to = ["author", "list", "recipients"]
>>>
>>> That would enable emails for issues found, with reply-all.
>>>
>>> (There's also a 'positive_review = "all"' setting that would enable
>>> emails for positive reviews, i.e. "Sashiko has reviewed this patch and
>>> found no issues. It looks great!"  But those are kind of noisy.)
>> Is it possible to configure it in a way that it only sends mails if it
>> really found something? ... always getting "Sashiko has reviewed this patch
>> and it looks great" mails is rather annoying than helpful ...
> 
> Yes, that's what I proposed above (and it's merged now).
Oh, -ENOTENOUGHCOFFEEYET ... Sorry, I should read more closely before 
answering ;-)

  Thomas

