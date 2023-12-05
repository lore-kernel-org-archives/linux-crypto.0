Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="epvSBOT0"
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B82FC4
	for <linux-crypto@vger.kernel.org>; Mon,  4 Dec 2023 16:48:47 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-548ae9a5eeaso2690a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 04 Dec 2023 16:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701737326; x=1702342126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxuWs5WeL5blIKEEZ0dpXLc7B+HhRdY1WEpcCPigzSk=;
        b=epvSBOT0gn0MixcpX3Jf1psGnK3p7vARTDuqdNOnID89p679gSFF0wqqp3MFZQnNmR
         onToYadGWvkagcbb+aiM85ALR22+KpTlk0jiJRMw0M47/hWVb9sd3962hWTeL6e1zlpR
         q0yAVEiLrSTbCZxVHmwDMU7KVGN5B7EwUVnCSVP4fKjz75qMGUo3lOj1DnOSENzfh14W
         Sp/QiHS3V/jpkDB6jGCm684fZzSBmO59vUTyG5w9eFSyYEzqGS1U2CvxlWtzwThB8EVp
         cYMVLrptM0uTa501ksqp4PV09lpT4gcnO58V6w6+ZZ9IcG0yrhWso0p+VyhRN7ox+Ef9
         Gm8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701737326; x=1702342126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lxuWs5WeL5blIKEEZ0dpXLc7B+HhRdY1WEpcCPigzSk=;
        b=gOCboslPR9WHXcvWN7wT6xuJ+MVCDieCpV/mFWf3+gxDKfKvLYS2ZcqiT5pYpAPaRw
         BZrxERtylLJ26uj1GBWnU7jFlQXXMsW7BaLHJiIXAPIpxASyqszHt6SYJMV9BD5P1Nvd
         V5hpwPWjDNfgezXHdXvwxMdnAkBV9GXSCWmUTTVXoy8Dc/QS8oTtA7P7iHTj7Z0ZA1TR
         Cgfw8xy+YN8cdQBxK1+d8EEoiNBloHzS2a1aXXbzBuG3ZaWUem1M6TEqjftsv07hr+GZ
         wlvOnRhiYt8ajO2tR7+F6EbW/RBf1udyScNcKluyUJ6q9UE82QV0GQ0kaP3aAfCCvgOy
         W3fg==
X-Gm-Message-State: AOJu0YyTBYt2F7HaGFBQxBLdGMVnnbsGfhCN1b5IjoiLA1hh+ag78BXs
	FXfYkjvJX4wQBqtfuWILkYhJ+kqgoCYwQ8RKnke80Q==
X-Google-Smtp-Source: AGHT+IGNw6BJISL+mPyQWP6VVQrK3THTpaodyhZoX81SuXtJCkb6I5Bmu7qpxkCPOCxVqNpCxDjzVMVB553aAyN2eNY=
X-Received: by 2002:a50:bb48:0:b0:54b:bf08:a95f with SMTP id
 y66-20020a50bb48000000b0054bbf08a95fmr474310ede.6.1701737325590; Mon, 04 Dec
 2023 16:48:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com> <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <20231110220756.7hhiy36jc6jiu7nm@amd.com>
 <ZU6zGgvfhga0Oiob@google.com> <CAAH4kHYPAiS+_KKhb1=8q=OkS+XBsES8J3K_acJ_5YcNZPi=kA@mail.gmail.com>
 <656e6f0aa1c5_4568a29451@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <656e6f0aa1c5_4568a29451@dwillia2-xfh.jf.intel.com.notmuch>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Mon, 4 Dec 2023 16:48:34 -0800
Message-ID: <CAAH4kHb7cfMetpC=AYy=FjTTve6g0W8NZdeSwQ8uVxkqi2491Q@mail.gmail.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com, 
	luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com, 
	pgonda@google.com, peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>, dan.middleton@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 4:30=E2=80=AFPM Dan Williams <dan.j.williams@intel.c=
om> wrote:
>
> [ add Dan Middleton for his awareness ]
>
> Dionna Amalie Glaze wrote:
> > > > So we're sort of complicating the more common case to support a mor=
e niche
> > > > one (as far as userspace is concerned anyway; as far as kernel goes=
, your
> > > > approach is certainly simplest :)).
> > > >
> > > > Instead, maybe a compromise is warranted so the requirements on use=
rspace
> > > > side are less complicated for a more basic deployment:
> > > >
> > > >   1) If /dev/sev is used to set a global certificate, then that wil=
l be
> > > >      used unconditionally by KVM, protected by simple dumb mutex du=
ring
> > > >      usage/update.
> > > >   2) If /dev/sev is not used to set the global certificate is the v=
alue
> > > >      is NULL, we assume userspace wants full responsibility for man=
aging
> > > >      certificates and exit to userspace to request the certs in the=
 manner
> > > >      you suggested.
> > > >
> > > > Sean, Dionna, would this cover your concerns and address the certif=
icate
> > > > update use-case?
> > >
> > > Honestly, no.  I see zero reason for the kernel to be involved.  IIUC=
, there's no
> > > privileged operations that require kernel intervention, which means t=
hat shoving
> > > a global cert into /dev/sev is using the CCP driver as middleman.  Ju=
st use a
> > > userspace daemon.  I have a very hard time believing that passing aro=
und large-ish
> > > blobs of data in userspace isn't already a solved problem.
> >
> > ping sathyanarayanan.kuppuswamy@linux.intel.com and +Dan Williams
>
> Apologies Dionna, I missed this earlier.
>

No worries, I've been sick anyway.

> >
> > I think for a uniform experience for all coco technologies, we need
> > someone from Intel to weigh in on supporting auxblob through a similar
> > vmexit. Whereas the quoting enclave gets its PCK cert installed by the
> > host, something like the firmware's SBOM [1] could be delivered in
> > auxblob. The proposal to embed the compressed SBOM binary in a coff
> > section of the UEFI doesn't get it communicated to user space, so this
> > is a good place to get that info about the expected TDMR in. The SBOM
> > proposal itself would need additional modeling in the coRIM profile to
> > have extra coco-specific measurements or we need to find some other
> > method of getting this info bundled with the attestation report.
>
> SBOM looks different than the SEV use case of @auxblob to convey a
> certificate chain.

The SEV use case has a GUID table in which we're allowed to provide
more than just the VCEK certificate chain. I'm using it to deliver a
UEFI endorsement document as well.

>
> Are you asking for @auxblob to be SBOM on TDX and a certchain on SEV, or
> unifying the @auxblob format on SBOM?

Given SEV is both certchain and SBOM and TDX doesn't need a certchain
in auxblob, I'd just be looking at delivering SBOM in auxblob for TDX.
It's probably better to have something extensible though, like SEV's
GUID table format. We may want to provide cached TDI RIMs too, for
example.

>
> > My own plan for SEV-SNP was to have a bespoke signed measurement of
> > the UEFI in the GUID table, but that doesn't extend to TDX. If we're
> > looking more at an industry alignment on coRIM for SBOM formats (yes
> > please), then it'd be great to start getting that kind of info plumbed
> > to the user in a uniform way that doesn't have to rely on servers
> > providing the endorsements.
> >
> > [1] https://uefi.org/blog/firmware-sbom-proposal
>
> Honestly my first reaction for this ABI would be for a new file under
> /sys/firmware/efi/efivars or similar.

For UEFI specifically that could make sense, yes. Not everyone has
been mounting efivars, so it's been a bit of an uphill battle for that
one. Still there's the matter of cached TDI RIMs. NVIDIA would have
everyone send attestation requests to their servers every quote
request in the NRAS architecture, but we're looking at other ways to
provide reliable attestation without a third party service, albeit
with slightly different security properties.

--=20
-Dionna Glaze, PhD (she/her)
