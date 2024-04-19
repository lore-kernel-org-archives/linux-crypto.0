Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A70477F13
	for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543226; cv=none; b=bZav1OORGKzj7XNEqvB137JzClinpui++Ebu5eC+2ZsELUeGmjgySvEdmrc8jt4Y2HTjIBXWJhtZ4eceQawbw/2KeoHI/mEvPPoT7CVxItoR002zwQhDNB1bADSBE6rDWy1RH5OUflpJDOzBeoE/kc6CGPD54Q7FboPKbOI0NHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543226; c=relaxed/simple;
	bh=nLxECB9bMpQI6z8V9G04dNBlY46x4K0VVLSohnbBzYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EYFzRtdjPF5qSCUvkoLPDDe7Es3jtuF7XhNuQK/0oi1M2pz7pahpLTTCFdg4tYKCfJ+jRvJmknOKGRqG7fHvGYLoYX2M6VUOs2BXRAQufcaW0tb1SYxETHBDt3t9grP+nlg9ZlknZPR0VlQNIZSxJQbn1BEo7al69cT/U1IrffI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HIZVcVIu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HIZVcVIu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713543224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nLxECB9bMpQI6z8V9G04dNBlY46x4K0VVLSohnbBzYs=;
	b=HIZVcVIu5JU7nFfDo41kCjTnm+RMgxeVliRcaRd/FHxUsqySdBFjsazv93AKd2dyKUQzCF
	Arbfbhudwhq6HnC0OoX0Y9vT3x2OlDjW/dbJYJRPAp93LRxgfDj6DtACBbmZK6yPzzJTrt
	k03tIz8HxfSLX6T3jnboMr9pXrM7uwc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-H7_h92qUOSKXZ9uNw6biHA-1; Fri, 19 Apr 2024 12:13:42 -0400
X-MC-Unique: H7_h92qUOSKXZ9uNw6biHA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-346772358easo1358423f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 19 Apr 2024 09:13:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543221; x=1714148021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nLxECB9bMpQI6z8V9G04dNBlY46x4K0VVLSohnbBzYs=;
        b=JcUc3PylGXJrJcWC62FHf4df1MHM/mExrqXjbtCc6UTL8YRdVovrCeBk8YTC25RZ18
         bWKpNysQ+5/zsW3x8/iBlMXhccQ20LKRILCUkD19iiSGgTC+mx2wht+DQNyfNW1xXe0l
         uqFTedT6PoCilQo4d/0hSIEkmGa1VazGMMo7Y1IUkwKyWjUKSlXbTVxcmgtQT5V+1bK6
         YU9biDS7BFGYA6CuC5UZEjtQHHZFk7/4SS1UxDXZ7rbhhZRD4nBMgphgEL8L2n1MB2ns
         MG7c1PKdc1M19EYCbrqo3I5m95FkKWk8jDuX9BhtVDxsVy1S47kqCXlf4ktrtqcLd6D/
         TYIg==
X-Forwarded-Encrypted: i=1; AJvYcCUmbfHi4PyfpPW17pv3WzCI2dAvKUO18vAIBTKbebnM+tr1fQrU6kq9cVpM8nt4/wUYh5QHG3OF1EIEvNnhswFg0dnOYy9JJUbpXry/
X-Gm-Message-State: AOJu0YzDG4JcP0gencFKzX/sp/32mo74I8JY4UHPZs0PbQv7dmmV+jyc
	xDDSf60fRouPpCqbPQT7OywHHYgjUfgb6jS8169dOUczkPzcjLacKlCdlwSUsreOYz9kAiWrbB7
	GxxaPanLgwZpMdU1CDl2bbSLD/3uZxF79tyRrT6IQB4DNbTBcV7aa1TtcgGZ7QtRc3cXaMxmMrz
	2sVKIhCkKVWI120iUlxyp/BS6jCYts9T3VKXav
X-Received: by 2002:a5d:5265:0:b0:345:66a1:d949 with SMTP id l5-20020a5d5265000000b0034566a1d949mr1596267wrc.0.1713543221701;
        Fri, 19 Apr 2024 09:13:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnajPMHcMdpRY04h+TNXdbRj7g/tI02Iw0JIqVHCpyfHEB4naUbmsOShyxFazrDJ7rYEXw5oIH9VgniqhruMA=
X-Received: by 2002:a5d:5265:0:b0:345:66a1:d949 with SMTP id
 l5-20020a5d5265000000b0034566a1d949mr1596246wrc.0.1713543221365; Fri, 19 Apr
 2024 09:13:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418194133.1452059-1-michael.roth@amd.com>
 <20240418194133.1452059-10-michael.roth@amd.com> <CABgObfYztTP+qoTa-tuPC8Au-aKhwiBkcvHni4T+n6MCD-P9Dw@mail.gmail.com>
 <20240419141920.2djcy6ag3peiiufn@amd.com>
In-Reply-To: <20240419141920.2djcy6ag3peiiufn@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Apr 2024 18:13:30 +0200
Message-ID: <CABgObfapuKAVHwMpQbAxMu5WJCz19twSpzRGbPannQ68-vPU6A@mail.gmail.com>
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

On Fri, Apr 19, 2024 at 4:19=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> So my current leaning is to send a v14 that backs out the major/minor
> policy enforcement and let firmware handle that aspect. (and also
> address your other comments).

Sounds good to me!

In the meanwhile I guess you can also update to have PFERR_PRIVATE_ACCESS.

Paolo

