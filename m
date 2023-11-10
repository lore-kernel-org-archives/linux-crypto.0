Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5634A2032A
	for <linux-crypto@vger.kernel.org>; Fri, 10 Nov 2023 22:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H3rkTedw"
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B98111
	for <linux-crypto@vger.kernel.org>; Fri, 10 Nov 2023 14:47:56 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5afe220cadeso36299687b3.3
        for <linux-crypto@vger.kernel.org>; Fri, 10 Nov 2023 14:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699656476; x=1700261276; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HDGYhhOiBni+WGtNPfLYpO88NsOvPheEqc/xC92J1aQ=;
        b=H3rkTedw7Bijy4b7ILwN1IKO/CjVZ/OdPrVDWaqe+KzsVxDhG8XYpEeEIF6dW3G/S3
         pvRW03R1grX8Kml7W4YBQgtOGDQfimMcGBo4H8O9SXPGiyVTZQnrL0PtS1K3c0f98Vfi
         4I7xEsY2TJfzLrhr10br8C+2j5dRzkV18uEhvp3ZpUHcq5q1AKLeheSpxNPz8qK4CeLE
         1P4FFxcsEM+59P1whp3KApRiZ67MNmlDZe6UHzxfj4kK7D0kOiqbAyV5/RYOqhXZRAfe
         E0QopdY1vdtd0yAvILh6clhvSkC/u93+ibWhB4yesxQrGpnR52eRyTNlh+CS4wEAeDfm
         MxqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699656476; x=1700261276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HDGYhhOiBni+WGtNPfLYpO88NsOvPheEqc/xC92J1aQ=;
        b=FnvjlkiqZ2oEyCpT4mzi1aHPU+J3G0JS/L3NJgaM//nnREGbuc1Z5Tjj6YkvwQjBib
         0pjWtQJIfn7trCRL6lixtGpDN+xjOEAqkU/T3PYe+lrOE4h70YilGbCLzjIIYYfEMtQ6
         J7BLjeiy+eIcpoLENuD8Chdyd0ur6BrPgFYh2wI7dGIFydiyuGjarBg6nAmGsdb7f/rk
         Heq8V4pusPATpeRMyFdaHkYSPvNu/rNqU1UdCtbVwkdIiEB51NQP2G1WDWR7HSWg6b00
         SJkN1IBtVlnyASav2vTs5zzGC1i0CV1HEPC3Uc1I3vN2GfZrBIVHFHZX4mhKq6KMaUZc
         aOLQ==
X-Gm-Message-State: AOJu0YwfYDWqlhgV4KuSdn2EvH38iVX1frLV7aez4Mr/XiQRw1TLY3no
	On+DqAIvhvh/PfXXOnmhQpJbDUWpJhA=
X-Google-Smtp-Source: AGHT+IGuCejQ9nzI6qVXkD9n/wUtUbU2Z8Vq+rLz0v+Hp4KUZKh+APKUTptATg9yX5HKoQF7ptWDVbyT1fU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6d4d:0:b0:576:af04:3495 with SMTP id
 i74-20020a816d4d000000b00576af043495mr17658ywc.9.1699656475780; Fri, 10 Nov
 2023 14:47:55 -0800 (PST)
Date: Fri, 10 Nov 2023 14:47:54 -0800
In-Reply-To: <20231110220756.7hhiy36jc6jiu7nm@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com> <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <20231110220756.7hhiy36jc6jiu7nm@amd.com>
Message-ID: <ZU6zGgvfhga0Oiob@google.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, Dionna Amalie Glaze <dionnaglaze@google.com>, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-mm@kvack.org, linux-crypto@vger.kernel.org, 
	x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, 
	ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com, 
	slp@redhat.com, pgonda@google.com, peterz@infradead.org, 
	srinivas.pandruvada@linux.intel.com, rientjes@google.com, 
	dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, 
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 10, 2023, Michael Roth wrote:
> On Wed, Oct 18, 2023 at 06:48:59AM -0700, Sean Christopherson wrote:
> > On Wed, Oct 18, 2023, Alexey Kardashevskiy wrote:
> > Anyways, back to punting to userspace.  Here's a rough sketch.  The only new uAPI
> > is the definition of KVM_HC_SNP_GET_CERTS and its arguments.
> 
> This sketch seems like a good, flexible way to handle per-VM certs, but
> it does complicate things from a userspace perspective. As a basic
> requirement, all userspaces will need to provide a way to specify the
> initial blob (either a very verbose base64-encoded userspace cmdline param,
> or a filepatch that needs additional management to store and handle
> permissions/etc.), and also a means to update it (e.g. a HMP/QMP command
> for QEMU, some libvirt wrappers, etc.).
>
> That's all well and good if you want to make use of per-VM certs, but we
> don't necessarily expect that most deployments will necessarily want to deal
> with per-VM certs, and would be happy with a system-wide one where they could
> simply issue the /dev/sev ioctl to inject one automatically for all guests.
> 
> So we're sort of complicating the more common case to support a more niche
> one (as far as userspace is concerned anyway; as far as kernel goes, your
> approach is certainly simplest :)).
> 
> Instead, maybe a compromise is warranted so the requirements on userspace
> side are less complicated for a more basic deployment:
> 
>   1) If /dev/sev is used to set a global certificate, then that will be
>      used unconditionally by KVM, protected by simple dumb mutex during
>      usage/update.
>   2) If /dev/sev is not used to set the global certificate is the value
>      is NULL, we assume userspace wants full responsibility for managing
>      certificates and exit to userspace to request the certs in the manner
>      you suggested.
> 
> Sean, Dionna, would this cover your concerns and address the certificate
> update use-case?

Honestly, no.  I see zero reason for the kernel to be involved.  IIUC, there's no
privileged operations that require kernel intervention, which means that shoving
a global cert into /dev/sev is using the CCP driver as middleman.  Just use a
userspace daemon.  I have a very hard time believing that passing around large-ish
blobs of data in userspace isn't already a solved problem.
