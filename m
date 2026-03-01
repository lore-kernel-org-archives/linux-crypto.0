Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4768430BB1
	for <linux-crypto@vger.kernel.org>; Sun,  1 Mar 2026 22:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772405657; cv=none; b=sLHuT52VBa98JZcvef1BYP31e5O6zg/E0EX0hyWMuGjaiPUeuu4MpGKg4aN72bY5RLB3yGlo9BAhgLk5ZLZkDRcYr4C0rQBRArtVjFMon0qdjF+J+tCLN0tAIYU52fhhwfJCHX97u0TaLcHe9gruM2xCwlmbU1g+Gaa+VikCayE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772405657; c=relaxed/simple;
	bh=hWimFkAbCnQKkjmXUNnbIpdWRffJFEUYePCetchgjnU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=beINBCbNADMmX6mqdrDvVcf/RuPuHATgMrG56nwyTYedEzxOQomUgkq+Go6ZswB9DgD1eJyVRn2HBRoSqARwRZJWCCAVZV2Cq5IomXkDkNf694jPAeO7kceyngbij7lwYQLJq4LII5y4QNPrZ+hGPusHS8cbn+4KW+TQE3HDOqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SJrWgywI; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SJrWgywI"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7984d31b895so34810267b3.1
        for <linux-crypto@vger.kernel.org>; Sun, 01 Mar 2026 14:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772405655; x=1773010455; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QA06iBtT4+hVWpWB+rxl5up+EwiLqT9T3dSRZKIAX60=;
        b=SJrWgywIYe5nUiEq6X9KdiwTbQGFozurAla1w6lLr7CH9SXC7UsrbZ4hQl3jwS0r1K
         OYw1gtgHEFqhbcHjiv8GLZ7ByeEi8zsxKBUAUtNbggn/W9jglO2bLDDs/3BNrJQ6Zv7s
         hTxT6SSyEEjB4t/m1xQrQF76Sn/5dIbaibXus369gR1Rjky4YvPQKyz84FOS6FMvLJce
         09rgcC5RLqDEBMWiZzITVgcNXK+BzGK+2Ji8T7hTRIkExnP+sJ6/jv7VQEgSCI1DoEsI
         SyP/ucdnXNZLwqaBTQaF6aAxhPQ9DN1N9AcVlBlcF+ny6yju6QypQ5L0U/ImteTtqV3L
         vFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772405655; x=1773010455;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QA06iBtT4+hVWpWB+rxl5up+EwiLqT9T3dSRZKIAX60=;
        b=ur2iygcRUW6s0ktWQvnjAOdbyFLaKWYJ5RSFYIE0a0Kj/4WFNt9dDBQHOowSoh8guJ
         So7KGP8oXlFRZV+++HklaUCYar79QXg/fLPYW5JcXAo+h2mDQSp9bFkdsdPGMIWjapAg
         26K1ZZT7l9Trgr18+Rz7SAFFFpPdSNKLlL0xBSf0bNFSZpqOKFcSKuZFlgkxAKEUsnbI
         WgiJqFrdTaIQO+ck3VuNoGSpCw9reHE/EvVx6stRDx9bC4h39UJaxWVyMrm/xW448fF4
         CX1CfxMljlYK3O5mPngm1uxHfb8pA+FolWCzU2UjsJMGfhafh2MKrO9l/8QAhICGKMdp
         DalA==
X-Forwarded-Encrypted: i=1; AJvYcCUSVwgHykhE6X5vIWyxBf16rRGMPTCtLD8o4D9uWtgVVBs0n4OxBl2wIQGPLAbj2hyZixM7P7J0ihXw23c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbOM9GMDW1YxP5K1UqaOWKeAuJJzvhaIw1TY+8wtIMRzrKJto/
	orm5Ncz1ub6jIH6BA3sWaQrE8eS577MJaVQ2kCoCOXTSyM7Lxb8Fgy6x
X-Gm-Gg: ATEYQzyHFeJPNY8mcSr2Y/wJtY9AErvLHNeQ9J6RwE6reOeYmx951w/ePPvfptWYXum
	hOtJANRwBHNNUVUku013Gpg8hnrpv+ZG8YAiOobZXtkK7ZSTFmwFxbcyA/5LzPdTkwQVtE1MrX0
	Xb6Cy9YaHi5nmYAM+AQYJVhS94lST4jnEUlhrq5oKtcn6pKiB4sgC7g2Fxem9ZwRvvz4wWFcLyF
	JpnW6kSqWGQkG5EJOwlhIGN1DeRiXwW54LT7qoz/qMNxZ/DPww/W/JjKgVU8ddlLjvvf7zlvxOL
	GiID8GJ4Dtn0igDvI+5XgsqRYTC8rlph6/BWOjTVLveZPqUQxiFuvJqEYlm1UGj5IiHUlbXRnVF
	ap6WwPSyYudkRXQzyVJ5aKyHdEdGy0KBl4Q5xb1ssCar6Q62bG/0JMoeX5xZuj2rcdNeidrWhds
	/LMUHbRmnZtcc2+o296Nt+CcAEnWCSMK9BygjVuSMywc1wPPzhzwhdvZSU0JdheZILt/U1WqVCb
	2PoriLOWkkZZptlScGunorigJ8FQoHI
X-Received: by 2002:a05:690c:4:b0:798:1637:ff0e with SMTP id 00721157ae682-7988551515dmr96160267b3.22.1772405654784;
        Sun, 01 Mar 2026 14:54:14 -0800 (PST)
Received: from localhost ([2601:7c0:c37c:4c00::5c0b])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79876ca7354sm43742537b3.52.2026.03.01.14.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 14:54:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 01 Mar 2026 16:53:50 -0600
Message-Id: <DGRTCXXMP7OJ.ZETCDPV2WZN4@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, "Keerthy" <j-keerthy@ti.com>,
 "Tero Kristo" <t-kristo@ti.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: sa2ul: add missing IS_ERR checks
From: "Ethan Tidmore" <ethantidmore06@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>, "Ethan Tidmore"
 <ethantidmore06@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260216231609.38021-1-ethantidmore06@gmail.com>
 <aaJjsnV8rGLpxha_@gondor.apana.org.au>
In-Reply-To: <aaJjsnV8rGLpxha_@gondor.apana.org.au>

On Fri Feb 27, 2026 at 9:40 PM CST, Herbert Xu wrote:
> On Mon, Feb 16, 2026 at 05:16:09PM -0600, Ethan Tidmore wrote:
>> The function dmaengine_desc_get_metadata_ptr() can return an error
>> pointer and is not checked for it. Add error pointer checks.
>>=20
>> Fixes: 7694b6ca649fe ("crypto: sa2ul - Add crypto driver")
>> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
>> ---
>>  drivers/crypto/sa2ul.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>=20
>> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
>> index fdc0b2486069..58d41c269d62 100644
>> --- a/drivers/crypto/sa2ul.c
>> +++ b/drivers/crypto/sa2ul.c
>> @@ -1051,6 +1051,9 @@ static void sa_aes_dma_in_callback(void *data)
>>  	if (req->iv) {
>>  		mdptr =3D (__be32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl,
>>  							       &ml);
>> +		if (IS_ERR(mdptr))
>> +			return;
>
> Thanks for adding the error checks.  However, if we get an error
> here shouldn't we still free the resources and pass the error up
> to the caller?
>
> Thanks,

Since this is a callback I'm not sure how to propagate the error. Nor am
I aware of the specific teardown required for this driver. I'll just
drop this patch for now, hopefully I was able to draw your attention to
this possible issue

Thanks,

ET

