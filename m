Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAFC82D99
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 11:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713527561; cv=none; b=OV7iAy1e66m/mhRnOsclIWeVWTapqYAlE7BB031XM5ZkNwxh5go0eMvG5IutFc8OOEEa7H5uIIFx5kT6/g/6DzjxajIOJBKTgo574haFIsEwewtfnlmnu5RIpEQ5vciIkp3P/0fDB8ecFPpG8DqqEr6vaj8YgN+6t80WW+ur2UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713527561; c=relaxed/simple;
	bh=+HnpYIljW903ODlD5/xLD4aOITxYFLDumzggzFZ3LXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e5gFN6YbBTK0SnTmj3UjB/IsYd1ib3FDCGAEsZLYdNMYx3I9AXbNDCRUYzZS7yPuHtuDAY33Q5+w1euyM5VGaVrN5kSTOHEWl7csoXszEh1RbWnnEHzBjxStvafw4RLMvRWnh0nQlebBumn6SfAr9RyWar+J3yDn/w98JUvPhJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QvHM1QVx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QvHM1QVx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713527559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+9gAW74TdLSgAKKdOeHRcIuNI+2QlXI+dYyfePDOsqM=;
	b=QvHM1QVxXd24ATflP4j3EP3JLsgHH5oOiuRX4z2SfJmPwCr+muAzsDosE8SrJGYIY7Jhc9
	inL0nS2Te9StRN2JXrNa7BuxSxoI4el830nrv7l6tByDJrXGMh0N0Msr5f4+Ke4wlFuhnr
	Yg8V0jb5hVKk0kuRJ51c8ZDua88CKOM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-cFhd3Ov-OzuTyDGs5FGOwQ-1; Fri, 19 Apr 2024 07:52:37 -0400
X-MC-Unique: cFhd3Ov-OzuTyDGs5FGOwQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-349d779625eso1485416f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 04:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713527556; x=1714132356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9gAW74TdLSgAKKdOeHRcIuNI+2QlXI+dYyfePDOsqM=;
        b=vDF2X/VFyWLPK9VSg0JwdRDtlxFewFAb1qm68JD5UHZ+bEd2N2lFkNFaK3ScuGUnKK
         nGY3RqJebbdtO9qxZYDBB+Xh0TH7pAgQ7czTKOSnozPpGWebjkXrWQp1cgY29+4vifoD
         NICsVV2ezzjc+nriHKpYFDQtCG4tbXMW3QoCrTPKHLPvss+gcTQSqqTF2gLD9e5Azmsj
         NOxAZu8N9OdKbCNYMvUumLxZDtWnfaFUJHUkAN7xrJDmXt4WtpXxSvGMqmYYW6IlFWYt
         B6R4kKcaaA0Mi8hPQoXN3EH2nXiN3OGGsbxWjVfVl1+eEyt1ymWMsl2jbag8I2c//Vqs
         91xQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5Ij8SSEOucFwSqIATL0A/x24dHAMW/RuNO97i5RfQyWUjf5Eph8ujfSnade7K4XeDZQfpUcILRlrQMY3V1w6qAvBi8+sOGKIMew/s
X-Gm-Message-State: AOJu0YysnI2THAODbkEA58ULG5ZZkE8IcRyKLK59iHqrTHZ45PDZjuSI
	Gdl/VyhbFzm7JZSUrwaXH/L5mK8rhWYT2u9HUhOQYzjUX79E0Ur7JDHteXuK0eOGVl2paF1SnBS
	yzZAWMzBqBQtpsHLWBXx+O4N/493vbKm9ZOfmMAap8VcsxTi+HP6HtdNEn8/b3NAylwHVS4356c
	2qGggie/W6zF0smfy+hkMpgh72iCIK5tJvM+IF
X-Received: by 2002:adf:e683:0:b0:345:605e:fa38 with SMTP id r3-20020adfe683000000b00345605efa38mr1433604wrm.60.1713527556826;
        Fri, 19 Apr 2024 04:52:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfUJrGef9Pu8qycGP8hLzLT/FO8q371w7fw92YbXK5+2PaDsTI6UQGUVVeBTULcSVYlzzGDl9d79lt6LyM70w=
X-Received: by 2002:adf:e683:0:b0:345:605e:fa38 with SMTP id
 r3-20020adfe683000000b00345605efa38mr1433571wrm.60.1713527556446; Fri, 19 Apr
 2024 04:52:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com> <20240418194133.1452059-10-michael.roth@amd.com>
In-Reply-To: <20240418194133.1452059-10-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 13:52:24 +0200
Message-ID: <CABgObfYztTP+qoTa-tuPC8Au-aKhwiBkcvHni4T+n6MCD-P9Dw@mail.gmail.com>
Subject: Re: [PATCH v13 09/26] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 9:42=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> +/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
> +#define SNP_POLICY_MASK_API_MAJOR      GENMASK_ULL(15, 8)
> +#define SNP_POLICY_MASK_API_MINOR      GENMASK_ULL(7, 0)
> +
> +#define SNP_POLICY_MASK_VALID          (SNP_POLICY_MASK_SMT            |=
 \
> +                                        SNP_POLICY_MASK_RSVD_MBO       |=
 \
> +                                        SNP_POLICY_MASK_DEBUG          |=
 \
> +                                        SNP_POLICY_MASK_SINGLE_SOCKET  |=
 \
> +                                        SNP_POLICY_MASK_API_MAJOR      |=
 \
> +                                        SNP_POLICY_MASK_API_MINOR)
> +
> +/* KVM's SNP support is compatible with 1.51 of the SEV-SNP Firmware ABI=
. */
> +#define SNP_POLICY_API_MAJOR           1
> +#define SNP_POLICY_API_MINOR           51

> +static inline bool sev_version_greater_or_equal(u8 major, u8 minor)
> +{
> +       if (major < SNP_POLICY_API_MAJOR)
> +               return true;

Should it perhaps refuse version 0.x? With something like a

#define SNP_POLICY_API_MAJOR_MIN    1

to make it a bit more future proof (and testable).

> +       major =3D (params.policy & SNP_POLICY_MASK_API_MAJOR);

This should be >> 8. Do the QEMU patches not set the API version? :)

Paolo

