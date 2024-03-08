Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FE94E1D0
	for <linux-crypto@vger.kernel.org>; Fri,  8 Mar 2024 07:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709882270; cv=none; b=Uzrr6Nk0jpxfjoqDumJycJGe8mT6PeNnDyBq6Tx90nrkmC/DhydO9fNW/uA97gWi1AY1zWKGnzFMiKoqAul9rQrcNBG6vOneb1FCod9YxyGHZUH+2d7a6nUGK6LOauHbUlVeQn8rgM++Zkmt8rtW7hC2mzJvNw86v2slxR4kfXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709882270; c=relaxed/simple;
	bh=7YvX8bPEV2BI0BpF/k+pwUbl0NZXlnKf36uLhchuK3c=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=tPadfrWSu7BaGqxISgpa9UB49xdClQArU9wtON9DTVZ+E4drg3rIWXS9gaJncz6FwkUvxVX1TUAw6YxltdEdQQJCGy0W84taBXYk/2b7yzfs7Cy5UVm+598VudYd3Z73+3nPPdsiHR2/rgTcjn30BUSUaPCUM0O74wpgNyNS7D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=wY2EXBE3; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="wY2EXBE3"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a44cdb2d3a6so256939966b.2
        for <linux-crypto@vger.kernel.org>; Thu, 07 Mar 2024 23:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1709882267; x=1710487067; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7YvX8bPEV2BI0BpF/k+pwUbl0NZXlnKf36uLhchuK3c=;
        b=wY2EXBE3RgnvRgIRgvNXAu0XaxznWS/lRKYE/yZan4fyg5gNzBdcUrM04WdkGqHVB2
         mjQZaq4d1yfvCqEuFK90mCV88VaUxF7hXrtsiJjPs70czaeKzim1k14JncL+ocDaEgcn
         2UMDciaIaSSChda5IM78oSxkGOBtmHfXsGbWkkjYnG+UtJyMITmL+a21fGtdgm1LIFfY
         hoghNkLCbD0R3yj1h6fMTBEa4p6aP33cgR+h/MHI/v0YR7xWVh+rHKSLoF9D1/xZW6t1
         p6e3rtX0xTONQuGCN5B5niLgD3J4t9L8WA5FiopdLHuJjKJD31MDladddp3JQPUcIZ2M
         +I6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709882267; x=1710487067;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7YvX8bPEV2BI0BpF/k+pwUbl0NZXlnKf36uLhchuK3c=;
        b=K0QRHSHpMemtwyfwfNL4LU+DhF740SHn+y1MqLFypAHY3RYvZL6PCGXGmaGQDcvk16
         s2Igg3rTPXo2AWQi6Drt23MOxhQ74OEOyGbR/DAqEtaqjzj+Mbh/i1q/7WtJTxC3c2Ls
         Mg/6UQe/LAzRGc5jpXnHTCohOcEAP8LF+DbNcEoyx8iAZT4ZI01oK68VuNBoMLFqiKG1
         S0F+7W/2v4mEqvV4tPubQLGePcuXMvl/pwBGG2ZTpEuEDoQaUiZwEMUgLFWojEwHbewX
         dJIVWqRp2m2g7ScMpr2oSZbni6cmhsUbAo+IvHyxslhQDiOyxC3rq3u5SZXSLIUjqOr4
         2+NQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3+8VzY5QSNF+VQrHYeiO7jh3uJL4u7X7ukUSsPlLFFttEzqufeFQH3uYl+KMSVEV5MlemzcKuFAA74Nu+2xJw/0K7jNR83veO0OZ0
X-Gm-Message-State: AOJu0YzqoQN8qDE4ogJUsBHO5Z+hF7Fro4LuiZmC/KxLL98FqWE+i1Kr
	7Xue7/sJ+banvL82wG2AHKprhY0jOs6p1SVkb8Cqiy8h3FhTRUXHwGQR3nWJ/NM=
X-Google-Smtp-Source: AGHT+IGiGod9W2YM4YZ6sUKkrNh7qVjymDesOFOXF8mtdCcbqIFTzGM2YQaR07gH4KtP9j0849dGZQ==
X-Received: by 2002:a17:906:339a:b0:a44:ff95:3911 with SMTP id v26-20020a170906339a00b00a44ff953911mr11831490eja.66.1709882267100;
        Thu, 07 Mar 2024 23:17:47 -0800 (PST)
Received: from smtpclient.apple (clnet-p106-198.ikbnet.co.at. [83.175.106.198])
        by smtp.gmail.com with ESMTPSA id f27-20020a170906085b00b00a44ef54b6b6sm6582541ejd.58.2024.03.07.23.17.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2024 23:17:46 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Re: [PATCH v6 3/6] KEYS: trusted: Introduce NXP DCP-backed trusted
 keys
From: David Gstir <david@sigma-star.at>
In-Reply-To: <CZNRMR5YZPQO.1QBLW62A6S840@kernel.org>
Date: Fri, 8 Mar 2024 08:17:35 +0100
Cc: Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <jejb@linux.ibm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Shawn Guo <shawnguo@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 "kernel@pengutronix.de" <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>,
 NXP Linux Team <linux-imx@nxp.com>,
 Ahmad Fatoum <a.fatoum@pengutronix.de>,
 sigma star Kernel Team <upstream+dcp@sigma-star.at>,
 David Howells <dhowells@redhat.com>,
 Li Yang <leoyang.li@nxp.com>,
 Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Tejun Heo <tj@kernel.org>,
 "Steven Rostedt (Google)" <rostedt@goodmis.org>,
 linux-doc@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
 "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org,
 "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>,
 Richard Weinberger <richard@nod.at>,
 David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Content-Transfer-Encoding: quoted-printable
Message-Id: <655221B7-634C-4493-A781-CF014DFFC8BF@sigma-star.at>
References: <20240307153842.80033-1-david@sigma-star.at>
 <20240307153842.80033-4-david@sigma-star.at>
 <CZNRMR5YZPQO.1QBLW62A6S840@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
X-Mailer: Apple Mail (2.3774.400.31)

Hi Jarkko,

> On 07.03.2024, at 20:30, Jarkko Sakkinen <jarkko@kernel.org> wrote:

[...]

>> +
>> +static int trusted_dcp_init(void)
>> +{
>> + int ret;
>> +
>> + if (use_otp_key)
>> + pr_info("Using DCP OTP key\n");
>> +
>> + ret =3D test_for_zero_key();
>> + if (ret) {
>> + pr_err("Test for zero'ed keys failed: %i\n", ret);
>=20
> I'm not sure whether this should err or warn.
>=20
> What sort of situations can cause the test the fail (e.g.
> adversary/interposer, bad configuration etc.).

This occurs when the hardware is not in "secure mode". I.e. it=E2=80=99s =
a bad configuration issue.
Once the board is properly configured, this will never trigger again.
Do you think a warning is better for this then?

Thanks,
- David

