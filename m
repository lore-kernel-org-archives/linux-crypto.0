Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0831990C7
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 05:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783055877; cv=pass; b=ZVYAc1FXXHT6PkXiYGrUbK8EQYeyfoNXIhuQyyvoaHHKtpkYQ4yV2rd/PB8BWhLAIS1y7nNqKkPEyi3yh9yy3L/VY9g1zU/Q5TFDYwePwdN6veXjbechtYkZEVCmCmLW55e2eff88hWifC7KYVPcU3UWtKogpLMkmFJDJgrG+UY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783055877; c=relaxed/simple;
	bh=KbIXfvFcY7x15KYIAFY7pXTV6R+NXbaxeXVE6hcTmcI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=okGjOTWyUyO90G6o1xYwiog3baOr6sqnLyfUtP0n4SsmFpqcPGvjWz02GnH4fsj5Q06PdqQ0bbBwuRhoaWS470IzerbkBm7gPSr6ue1pQCuMg6jjDme7tH4/iIAoWfMXerX6hH9w/cEzCUX4MoGMXQLhe/ekWaCSTxwCrPNCr6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=g+0MRnkP; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="g+0MRnkP"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e7632b193so10464585a.2
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2026 22:17:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783055867; cv=none;
        d=google.com; s=arc-20260327;
        b=kIoISmF8WOZw70NoK0qw4FqiPabnCpOQblLSvMRbjdkB4PeW9apwciLIXgH6K/QQM1
         ofPCs3o2FkYCHePGPFaQyTzkEmjGsX+ttdHlF+onSYO3utEQ5+w4luj1WboD3iWAmbwF
         XaCB6vcat9D1LDQpzDdatdCnMzlRtsZxh0Y8pAbA/Y5GoWBGmF83Wv0HQusXakC70V2T
         zn8zLwoE92W9KG2/VcCSKLfknjbczZE5TGB4HB+JjxxLQMMtjf6rZMnDFrMTGSlPjL+r
         qaKeHUnt0Wanl3s0IE7CU61izY4Ql1Bv2jtMIPcnHYzg+8K6UWpXjb0A6JVflKjLISBW
         81aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K6l3anb2Zu682WaKsqQwpeXUesaU9kfmxufkIavL57g=;
        fh=RhzgdNf808pRB0MsLexa5RPyfgI+lUPER0rVOePeWmI=;
        b=hqrZnPa6kCzggA3CzE2Oj5cJ6ofLzMgtdT1CInga/CMb9afADSBM+BHAw5Wane830Y
         BsGD1oFXnleKQiLh4pDKEKholUj+ye8pNTdU7XpKRFw5JD6G8spUcKVltmyRsMnCHwGV
         YertgD2MVC4g5UhwaF22HQKjgekqAjYTtH1GuHQdIA0/sq+x+qAVKcaCSGwEk+Mw/Xba
         lKXOjjaFmvqBj87LODKpp8yqfjWZ5FraEmzN+oFUybGNDSj8DpDxKr4g9SOR8bqRduTl
         KG1PCP0O6/WPSRXE31LMi+atW2kF7peUj5Z/1uqtv+MxKji8qcU0vgWX0MyuMRHrB+/E
         bjtQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1783055867; x=1783660667; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K6l3anb2Zu682WaKsqQwpeXUesaU9kfmxufkIavL57g=;
        b=g+0MRnkPUimKwTvO4SsSN2/j9e/ly0Wvqswq7DM9k2+dEVJz1p/GrnLB/UWZEXKp8P
         XhRT14fWfltL8EN+GMmIv9ILaZq1eJ0igoQMGJQ8o+7x6D+CSZr2RAtPxrgfWsSYxLBi
         185n4KQC+AqZxElkyEIjqAanIfGh8DEIPdNTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783055867; x=1783660667;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K6l3anb2Zu682WaKsqQwpeXUesaU9kfmxufkIavL57g=;
        b=Wo/dO5lL1rzClgheuCk1l0jXx4MsUN+vIb3q+RVRRnPyeH6QM3ytKy38/aLi7Z/WrR
         eMJqHZf09DDTPK0ceOt6eY259vzTnwk/yA2KXOO5i4Fco28juNxqlhfCR293PaYoSlTH
         HmRkuNkdbzR2qOmlGRXUPIN7is2RiY42G7Am6KbFG8fUgzzMe74XQ5vfO2QJQ4O4lMgS
         JCYH1cbhe16mVGlr5cquBk60v5N7Ak6xnVZMzDq/hOarilqdmQQs8nNHj+O3dJHdqhBi
         4keSYnaGUU7sUWqfwSS4PB6NcGdtab1RnKamuUi1FRDeukWQuxdeFgwPgTqVF5OiOLcJ
         HqLA==
X-Gm-Message-State: AOJu0YzK5+Z0wjMBauvV/LZ/KhUByOfIc3O+QjEdYtU7E2SjV5eKbvzj
	Z6O/EEYO0QctlJ5KEz9JGKJ0aAII1a2Dbusm5E0th/wqNfActFcnfqP7rYRRXbjAkE55RKLzrNH
	YvVvIR58Enmz/Z+F+Vs6RCqNvUSbix48vdJgc9xcKDg==
X-Gm-Gg: AfdE7cmKNRv+WqzwZoCxmslBK8znfWXP+Ro0nNBwoIbqvOGij32UiBu6Ar+wcGq8R63
	O9SOGdZ68xyj6pMyd1EVe+gkZcIx8U3qIGBFZsupBh2EsnRa6HqpBeFEU2/CMGCDslAsy4c3BVD
	9v9i1rtoyLj332rBiOF4maXfzW0Tk0E/askTLEyWCRsYc3TnULEiL+gGTW+PJ2bDZuFBNmgZOSz
	AcxNdMWqlsl8mVmxd0Nrv3L82uNfnVPtlhxX/09XQGQ+2ggrRnkLYOBVl7+QA+R5aulIEUQtff0
	fV/M19+ylrZSpbLhH0JoOjtLw04gagii8RhEfsyaCVKWX3DpdPceS6sjqR3BO2gA3Zb/ptOiMs+
	jzaIiIH1AmnXP4ATLbWgiLYUCiru9o1aGfw00vr71Gq3nsvLt
X-Received: by 2002:a05:6214:3206:b0:8e7:8d53:240f with SMTP id
 6a1803df08f44-8f4248cf761mr110821046d6.43.1783055867015; Thu, 02 Jul 2026
 22:17:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701122941.2149121-1-pavitrakumarm@vayavyalabs.com>
 <20260701122941.2149121-5-pavitrakumarm@vayavyalabs.com> <deb73385-a7a9-4ea9-8338-b7da999a5e9c@gmail.com>
In-Reply-To: <deb73385-a7a9-4ea9-8338-b7da999a5e9c@gmail.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 3 Jul 2026 10:47:36 +0530
X-Gm-Features: AVVi8Cf_Mm6lcVGfPvzxRziLw13q7u7bjan5v_Vba5wx3_pZK1z-DIssqtslyN8
Message-ID: <CALxtO0nLReV_qoxP6q46a2kSXrsXOsWW18ZZ9aFagn5ATSpk6w@mail.gmail.com>
Subject: Re: [PATCH v15 4/4] crypto: spacc - Add SPAcc Kconfig and Makefile
To: Julian Braha <julianbraha@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org, 
	krzk@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com, 
	rbannerm@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Julian,
   Ack, I will fix the typos and spaces.

Warm regards,
PK


On Fri, Jul 3, 2026 at 12:48=E2=80=AFAM Julian Braha <julianbraha@gmail.com=
> wrote:
>
> Hi Pavitrakumar,
>
> On 7/1/26 13:29, Pavitrakumar Managutte wrote:
>
> > +config CRYPTO_DEV_SPACC_DEBUG_TRACE_IO
> > +     bool "Enable Trace MMIO reads/writes stats"
> > +     default n
> > +     help
> > +       Say y to enable Trace MMIO reads/writes stats.
> > +       To Debug and trace IO register read/write oprations.
> > +
>
> Typo in "operations".
>
> > +config CRYPTO_DEV_SPACC_DEBUG_TRACE_DDT
> > +     bool "Enable Trace DDT entries stats"
> > +     default n
> > +     help
> > +       Say y to enable Enable DDT entry stats.
> > +       To Debug and trace DDT opration
>
> Another typo in "operation".
>
> > +
> > +config CRYPTO_DEV_SPACC_CONFIG_DEBUG
> > +     bool "Enable SPAcc debug logs"
> > +     default n
> > +     help
> > +          Say y to enable additional debug prints and diagnostics in t=
he
>
> Most of your kconfig formatting looks okay, but you strangely have 8
> spaces here in your help text.
>
> - Julian Braha
