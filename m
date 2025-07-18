Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290382DCF73
	for <linux-crypto@vger.kernel.org>; Fri, 18 Jul 2025 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752852805; cv=none; b=hQL+qN1oXyfPosgnNQhhWIL/VQ4H1uX1vZBffuUk9WjWam63NgxgvYdYq4eUNfuAS2UjiAWgcj18tGIKxdmCbMJKHrs1kyKLEliUc/qwHcZsRBm4498f1/YLcvsceQE4pYqeqFWGC52VE5Lf7rZSoS1Y/vR0/tOF1X3w7GgM1as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752852805; c=relaxed/simple;
	bh=geRwiammgshPEkZTEfrGjM87emalk67t+A5KtRwbf2w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HC9BslXjBf/tPWzVz0pi4HkyGCL646Abfk8avGUNa6xOyLtch/zwk08SqsOMlv7RKXTwT993YkcTHylStGq9IwV1qazUTLQV37HzptL9Et55Z1IrzN6FS30UglYco2qjepJfQNEfqOyK/w737VNz4npBgFz/lqD8x/LFv33Lmy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I2piDDsa; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I2piDDsa"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-315af08594fso2214174a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 18 Jul 2025 08:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752852803; x=1753457603; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5YSpj+1IV44+FVqvcifw9o0LIVQ8kEqDMxNOHmhaNXw=;
        b=I2piDDsa4spSBus4uCh4wAsogVuhyjMfbnvbaaMFUzLRgyuRS+0BoJEVq/tvo9zL5i
         YlITNYZyJnp0sl+MaYVaYKOZylkaspO+t1Cf1aYtCV855lGnHWSHBm0V6Dc5GJVl8aV5
         q5K2yFsa7CBkj4WhMZwpGBAaVJCx2yipBfv1MFVeoIg8vNV5XQOJjZsXHgSxrKuhIoOl
         XL7/89X7IPL/Q3Qex+vEf4oy846C+CGBU/P7Jfb49cgm0rdUxPA1vwV6vJtAY8F6yG+D
         qKwpt27TMaZjznooL2me/sA3GWF7XR+bUGRisjn4Hb4d3GJ7CYzkgm1dQXmcs8/Tp7OP
         JBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752852803; x=1753457603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5YSpj+1IV44+FVqvcifw9o0LIVQ8kEqDMxNOHmhaNXw=;
        b=wuNDr9dLTzH36wMD3WliI4sBMaBUsNPbmO/uK5RXfQnsPlF+eniTdlJGJEQvxBKt3B
         e/u59OS71qwMGaQ1WVX6X1jLRyenaV32GHDlV94lgTRiaM72cZ7CytaNsgBqoa3stH8V
         nbbhwh0uwtsmoDOLGRNsL4GcrevyO37HJQUxXIhcShEt2CrDsGVo1BsFeLl8h9iUtKwK
         QtlzHlVlC9EiKQ40RgvNsPpbAOR6fnoxCK5sUm1GuxNweJAt4cxMG7DQxPOUByVOFIGS
         lSjYxD8kD5t/Kh43bKq062NYyHha+s9qHNefZcqBuIBnwBLiK4hfDB2TSVm+1TUTQ4Zj
         F+pw==
X-Gm-Message-State: AOJu0Ywbdi9oFw/jORgfAAmmcshuhgO+QH21sXX0SGnoczuPQStv0SWL
	Vaxqh2c1wAL5qSArncbopNS7oQPGwvexcVTbmgIMB2kDjYh3eAbuUgpZAercJICqdIINsHExmCm
	RStoYsw==
X-Google-Smtp-Source: AGHT+IEucQrf6BnU8TPUHyXRYZd0lenwR3GNHW7YqoEv+LTUasMyddo4Blp0+FuBeMJX3DZ+HCVXGBvFB+4=
X-Received: from pjbsn8.prod.google.com ([2002:a17:90b:2e88:b0:311:6040:2c7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ec7:b0:311:ef19:824d
 with SMTP id 98e67ed59e1d1-31c9f435537mr15265871a91.2.1752852803229; Fri, 18
 Jul 2025 08:33:23 -0700 (PDT)
Date: Fri, 18 Jul 2025 08:33:21 -0700
In-Reply-To: <c502a550-3856-4c21-8546-b4b1abbd0abf@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250630202319.56331-1-prsampat@amd.com> <20250630202319.56331-2-prsampat@amd.com>
 <aG0jxWk1eor1A_Gd@google.com> <a5dbf066-a999-42d4-8d0f-6dae66ef0b98@amd.com>
 <aHBCosztx8QWC4G0@google.com> <c502a550-3856-4c21-8546-b4b1abbd0abf@amd.com>
Message-ID: <aHppQWM5TKPD7JpD@google.com>
Subject: Re: [PATCH 1/1] crypto: ccp - Add the SNP_VERIFY_MITIGATION command
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, bp@alien8.de, michael.roth@amd.com, aik@amd.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 16, 2025, Pratik R. Sampat wrote:
> 
> 
> On 7/10/25 5:45 PM, Sean Christopherson wrote:
> > On Wed, Jul 09, 2025, Pratik R. Sampat wrote:
> >> Hi Sean,
> >>
> >> On 7/8/25 8:57 AM, Sean Christopherson wrote:
> >>> On Mon, Jun 30, 2025, Pratik R. Sampat wrote:
> >>>> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
> >>>> can be used to query the status of currently supported vulnerability
> >>>> mitigations and to initiate mitigations within the firmware.
> >>>>
> >>>> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
> >>>> more details.
> >>>
> >>> Nothing here explains why this needs to be exposed directly to userspace.
> >>
> >> The general idea is that not all mitigations may/can be applied
> >> immediately, for ex: some mitigations may require all the guest to be
> >> shutdown before they can be applied. So a host userspace interface to
> >> query+apply mitigations can be useful for that coordination before
> >> attempting to apply the mitigation.
> > 
> > But why expose ioctls to effectively give userspace direct access to firmware?
> > E.g. why not configure firmware mitigations via the kernel's upcoming
> > Attack Vector Controls.
> > 
> > https://lore.kernel.org/all/20250707183316.1349127-1-david.kaplan@amd.com
> 
> Something like Attack Vector Controls may not work in our case, since
> those are designed to protect the kernel from userspace and guests,
> whereas SEV firmware mitigations are focused on protecting guests from
> the hypervisor. Additionally, Attack Vector Controls are managed via
> boot command-line parameters, but maybe we could potentially change
> that by introducing RW interfaces for our case within
> /sys/devices/system/cpu/vector_vulnerabilities (or what the final form
> of this interface ends up being).
> 
> Another option could be to expose this functionality in a subdirectory
> under /sys/firmware/?
> 
> However, with any of these approaches, we would still be giving
> userspace the ability to access and alter the firmware, similar to
> the interfaces that expose features such as Download Firmware EX
> also allow, right?

Not all userspace is created equal, e.g. init_ex_path is a module param, and
(un)loading modules requires CAP_SYS_MODULE.  The expected/desired use cases also
matter, e.g. if there's no use case for toggling mitigations after initial setup,
then the interface presented to userspace could likely be much different than if
there's a "need" to make mitigations fully runtime configurable.
