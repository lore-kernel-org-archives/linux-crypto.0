Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3694B1DE2C1
	for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2024 22:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734042638; cv=none; b=Pn+t9WhvtOFhAeqt51hlj6j0f3U0qcW+MJ4cheV1DwRg9Tgek6XuwbGsKLVqOTkTaSu2MS+vcnFZmRjfp+5VbBUOFUQ3WVaZ7qa8u3oRVMW3GF7UgQSP3W3ao/RLB3jRNJYyuhSBBkP7PJBWsQaduzU9X7ImBGl5DVioqoavHb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734042638; c=relaxed/simple;
	bh=PeBxRdt9kNG/k6+j3l9HUg4BLn3XzZxkSnQ+Plm8EBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FhJExkNhEK+4sKmjm5gpPGmrwishKkPQDHWGHJKEqAiMcxSeNdI7271dSb2N3dlAsa6SyIg+vmo29JDWzK8yR4t5ZgAEYQxTiHovos7RYp6i+sm9LpsYkGrEx5dhhwskbM2E5ICF27WedDceEV3yEpgOTV/rDaNg6UrvmzFrR4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=HfeNFeIg; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="HfeNFeIg"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa5f1909d6fso207131266b.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2024 14:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1734042634; x=1734647434; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DFfich0wCzNZpgo4PXY6tmakvrRskVcHsJ5GFyjyu8=;
        b=HfeNFeIg1ulZAfAZR1H4ysZNGOdTfBaptP0eA8xp431OtRDBBO++MAk/2xmOWQYgoW
         UjsZxPMYuHcrdLFsUpRMOrfvSLHOLr+h3wOzfiFlZJ25rST7v3LmitICo9+hUx9xkKeF
         Zz12TCVFP3m7XaVEmEa3kJDHjZC4aCfEoTpOcdxKCS7/pFIBFuAxPNXj+Bz6iFNR7gaH
         pTyNbxzcIVRg5yTU98ub6+xwm7zmvFgodCvdr/8TAYCk0sMfh5Is6qA3TyKjMAsrc3wE
         /P5SZHGC6CI8N6D3SVGaYL8F+PqHXLZlrezlmui96Ctiu9rXDcEoX0mDF7XfNEkgiBdh
         QcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734042634; x=1734647434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DFfich0wCzNZpgo4PXY6tmakvrRskVcHsJ5GFyjyu8=;
        b=ElLfNEyWQcBnLylcOKRK0tYvU02howBTqEfCXi6t9hJNGPpixr4bjNrG8oWtY9gwl3
         xCLIxt7AsoFpfMqws4gQfJ5+2TlyyPe2ThwQoP4Q8dFVhZITGaP9C1mjtpKeo8QHsqy0
         DQuNgMsRTTzDJZk8a3mHq1qlIIDvpu6lPQcnaIujtVZ0eK4sHpnf48TC+wEF/52+70fH
         xEfX3wyqoCrfKIcvvXlJQBRcHzSuFTfrU1MJLu5FJXyD//JuT434i8grs1NqTYow3l3i
         1yxkdfbwPlC/V0lwTQh2JLaVx0ehCnVbcl57iCQrq46XL1FyHvkVvzI/2LYsGkLRoACr
         0Ppw==
X-Forwarded-Encrypted: i=1; AJvYcCUYeayAP4LxpoFScfpkmMLaOfIYG5t82tvLOKZ9lvXOaOgaOmMRy46vFEV0FO5WLIAfLKd/bsmuAr+auK0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/MexAUscy2Ql6e5B3SmgvbckfLoAX7ogBk4TqnQn87j5XrGWD
	CujZwqlzHg+Nfx8SsRrTNuvSGd0KJxZOeBvytJpcXLZpmw7CtgbcvpbIsr/AGvCD9e3lhGkWRTl
	6epzgCKlgyWSu59XxGhgda+iV6UxyNj2aYeuv
X-Gm-Gg: ASbGncullB8pKUCQ1yDU224y/ONsuQpmYSLrPWgx2iCOkKdAuNSqlcGY0VeBEupQpIO
	QbmqxHpQbCBmPWTJOoDDh1HAcKs86N8JHqzw2
X-Google-Smtp-Source: AGHT+IGl1dmIiaH9NI8b8hOYdpWTfrRri9yyfmHuI52Jogvcc1hUauGAXPes+nuLyRdasCl6AgOKkv55XUwt8CfhqfE=
X-Received: by 2002:a17:906:c14a:b0:aa5:31f5:922a with SMTP id
 a640c23a62f3a-aab7797eb4emr40990566b.19.1734042634250; Thu, 12 Dec 2024
 14:30:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240531010331.134441-1-ross.philipson@oracle.com>
 <874jaegk8i.fsf@email.froward.int.ebiederm.org> <5b1ce8d3-516d-4dfd-a976-38e5cee1ef4e@apertussolutions.com>
 <87ttflli09.ffs@tglx> <CALCETrXQ7rChWLDqTG0+KY7rsfajSPguMnHO1G4VJi_mgwN9Zw@mail.gmail.com>
 <1a1f0c41-70de-4f46-b91d-6dc7176893ee@apertussolutions.com>
 <8a0b59a4-a5a2-42ae-bc1c-1ddc8f2aad16@apertussolutions.com>
 <CALCETrX8caT5qvCUu24hQfxUF_wUC2XdGpS2YFP6SR++7FiM3Q@mail.gmail.com>
 <c466ed57-35a8-41c0-9647-c70e588ad1d3@apertussolutions.com>
 <CALCETrW9WNNGh1dEPKfQoeU+m5q6_m97d0_bzRkZsv2LxqB_ew@mail.gmail.com>
 <ff0c8eed-8981-48c4-81d9-56b040ef1c7b@apertussolutions.com>
 <446cf9c70184885e4cec6dd4514ae8daf7accdcb.camel@HansenPartnership.com>
 <5d1e41d6-b467-4013-a0d0-45f9511c15c6@apertussolutions.com>
 <CALCETrW6vMYZo-b7N9ojVSeZLVxhZjLBjnMHsULMGP6TaVYRHA@mail.gmail.com>
 <9c80e779b6268fde33c93ed3765ff93b1d6d007b.camel@HansenPartnership.com>
 <CALCETrX4vHnVorqWjPEOP0XLaA0uUWkKikDcCXWtbs2a7EBuiA@mail.gmail.com> <61a4e812-9514-41a6-a000-e6c026a4ec45@apertussolutions.com>
In-Reply-To: <61a4e812-9514-41a6-a000-e6c026a4ec45@apertussolutions.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 12 Dec 2024 14:30:23 -0800
Message-ID: <CALCETrXQqR6Az7puNXLfhoL37iLHtG1qOyqC_K301TGmMOQvvA@mail.gmail.com>
Subject: Re: [PATCH v9 06/19] x86: Add early SHA-1 support for Secure Launch
 early measurements
To: "Daniel P. Smith" <dpsmith@apertussolutions.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Thomas Gleixner <tglx@linutronix.de>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Eric Biggers <ebiggers@kernel.org>, Ross Philipson <ross.philipson@oracle.com>, 
	linux-kernel@vger.kernel.org, x86@kernel.org, linux-integrity@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kexec@lists.infradead.org, linux-efi@vger.kernel.org, 
	iommu@lists.linux-foundation.org, mingo@redhat.com, bp@alien8.de, 
	hpa@zytor.com, dave.hansen@linux.intel.com, ardb@kernel.org, 
	mjg59@srcf.ucam.org, peterhuewe@gmx.de, jarkko@kernel.org, jgg@ziepe.ca, 
	nivedita@alum.mit.edu, herbert@gondor.apana.org.au, davem@davemloft.net, 
	corbet@lwn.net, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	kanth.ghatraju@oracle.com, andrew.cooper3@citrix.com, 
	trenchboot-devel@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2024 at 11:56=E2=80=AFAM Daniel P. Smith
<dpsmith@apertussolutions.com> wrote:
>
> Hey Luto!
>
> Let me try to address your concerns below.
>
> On 11/18/24 15:02, Andy Lutomirski wrote:
> > On Mon, Nov 18, 2024 at 11:12=E2=80=AFAM James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> >>
> >> On Mon, 2024-11-18 at 10:43 -0800, Andy Lutomirski wrote:
> >>> Linux should not use TPM2_PCR_Extend *at all*.  Instead, Linux should
> >>> exclusively use TPM2_PCR_Event.  I would expect that passing, say,
> >>> the entire kernel image to TPM2_PCR_Event would be a big mistake, so
> >>> instead Linux should hash the relevant data with a reasonable
> >>> suggestion of hashes (which includes, mandatorily, SHA-384 and *does
> >>> not* include SHA-1, and may or may not be configurable at build time
> >>> to include things like SM3), concatenate them, and pass that to
> >>> TPM2_PCR_Event.  And Linux should make the value that it passed to
> >>> TPM2_PCR_Event readily accessible to software using it, and should
> >>> also include some straightforward tooling to calculate it from a
> >>> given input so that software that wants to figure out what value to
> >>> expect in a PCR can easily do so.
> >>
> >> Just for clarity, this is about how the agile log format works.  Each
> >> event entry in the log contains a list of bank hashes and the extends
> >> occur in log event order, so replaying a log should get you to exactly
> >> the head PCR value of each bank.  If a log doesn't understand a format=
,
> >> like SM3, then an entry for it doesn't appear in the log and a replay
> >> says nothing about the PCR value.
> >
> > I have no idea what the "agile log format" is or what all the formats
> > in existence are.  I found section 4.2.4 here:
> >
> > https://trustedcomputinggroup.org/wp-content/uploads/TCG_IWG_CEL_v1_r0p=
41_pub.pdf
> >
> > It says:
> >
> > This field contains the list of the digest values Extended. The Extend
> > method varies with TPM command, so there is
> > no uniform meaning of TPM Extend in this instance, and separate
> > descriptions are unavoidable. If using the
> > TPM2_PCR_Extend command, this field is the data sent to the TPM (i.e.,
> > not the resulting value of the PCR after the
> > TPM2_PCR_Extend command completes). If using the TPM2_PCR_Event
> > command, this field contains the digest
> > structure returned by the TPM2_PCR_Event command (that contains the
> > digest(s) submitted to each PCR bank as
> > the internal Extend operation). This field SHALL contain the
> > information from the TPML_DIGEST_VALUES used in
> > the Extend operation.
>
>
> Let me start with providing background on the two measurement policies
> that is implemented by Intel TXT (from Intel TXT Developers Guide):
>
>   - Maximum Agility PCR Extend Policy: ACM can support algorithm agile
> commands TPM2_PCR_Event; TPM2_HashSequenceStart; TPM2_HashUpdate;
> TPM2_EventSequenceComplete. When this policy is selected, ACM will use
> the commands above if not all PCR algorithms are covered by embedded set
> of algorithms and will extend all existing PCR banks. Side effect of
> this policy is possible performance loss.
>
> =E2=80=92 Maximum Performance PCR Extend Policy: ACM can support several =
hash
> algorithms via embedded SW. When this policy is selected, ACM will use
> embedded SW to compute hashes and then will use TPM2_PCR_Extend commands
> to extend them into PCRs. If PCRs utilizing hash algorithms not
> supported by SW are discovered, they will be capped with =E2=80=9C1=E2=80=
=9D value. This
> policy, when selected, will ensure maximum possible performance but has
> side effect of possible capping of some of the PCRs.
>

What is responsible for choosing which of these policies to use?

> Allow me to clarify/expand on the last statement in Maximum Agility.
> There is almost certainly a performance loss as anything larger than
> 1024 bytes, for example the Linux kernel, the ACM will bit-banging the
> bytes to the TPM using the TPM2_Hash* functions.

Surely, if Linux's stub started using TPM2_PCR_Event, it would first
hash any large inputs and then send the _hash_ to TPM2_PCR_Event
instead of, say, bit-banging the entire initramfs to the TPM.  But
you're talking about the ACM and I'm talking about the Linux stub code
in this patchset.

But the capping-with-"1" does suggest that maybe one can actually cap
with "1" without preventing downstream software from consuming the
event log.

>
> Before addressing the next point, I would also clarify how the D-CRTM
> measurement taken by the CPU is done. It uses the _TPM_HASH_* functions,
> Section 22.9 of TPM2 Commands specification, to store SHA256(SINIT ACM)
> | EDX into all active PCR banks. For clarity, when this done, EDX holds
> the 4-byte value of the SENTER parameters for which 0 is the only valid
> value currently.
>
>
> > So we're logging the values with which we extend the PCRs.  Once upon
> > a time, someone decided it was okay to skip extending a PCR bank:
> >
> > https://google.github.io/security-research/pocs/bios/tpm-carte-blanche/=
writeup.html
> >
> > and it was not a great idea.
>
>
> Let's begin by why/how that attack occurs. The TPM Carte Blanche attack
> took advantage of the fact that without BootGuard in place, the SRTM
> measurements are done by the software/firmware, to include the
> self-referential S-CRTM measurement. In particular, for the target
> platform, it just so happens that it was possible to construct a
> configuration where not a single hash would be sent to the SHA256 bank.
> This allowed the attacker the ability to replay any set of measurements,
> i.e. carte blanche control, into a completely empty PCR bank for which
> the attestation service would accept quotes. The key to this attack
> requires both, access to an empty PCR bank, and an attestation service
> that will accept a quote with only the exploited bank present.
>
> Let us return to my statements above, which will demonstrate why
> TXT/DRTM completely invalidates the attack. First, as noted above, when
> the CPU is processing the GETSEC[SENTER] instruction, it (the CPU) will
> compute the D-CRTM as SHA256(SINIT ACM) | EDX, sending it to the TPM
> using _TPM_HASH_* functions. The _TPM_HASH_* functions result in all PCR
> banks to be extended with the D-CRTM value. If Maximum Performance PCR
> Extend policy is in use, which is the default policy used by TrenchBoot,
> any algorithm not supported by the ACM is capped by sending the value
> "1" as the digest value for the extend. Therefore, after the TXT
> sequence has completed and before control is given to the Linux kernel
> by the ACM, all PCR banks will consist of either, the D-CRTM + all ACM
> measurements, or the D-CRTM + TPM2_PCR_Extend(0x1). There will be no PCR
> banks with empty DRTM PCRs, thus none of the banks would be usable for a
> TPM Carte Blanche-style attack.

Sure, a "carte blanche" attack in the sense that the PCRs are entirely
blank won't happen, but if any component in the chain does not extend
a bank, then an attacker can replace the code _after_ that component
without being noticed.

> (c) Upon initialization, cap the PCR banks with unsupported algorithms
> using a well-known value.
>
> A problem with (a) is that the result will be an unorthodox event,
> PCR_EXTEND(H(H'(data))). An attestation verifier will have to be aware
> of that this is being done, and have a way to determine which method was
> used for each event. This creates a potentially expensive cost for any
> existing attestation solutions to incorporate support for the unorthodox
> event. At least for DRTM solutions, it seeks to solve a problem that TXT
> does not experience.
>
> For Linux Secure Launch, I would like to propose an alternative to what
> the current logic does in the setup kernel. Specifically, Secure Launch
> will trigger a TXT reset when an unsupported algorithm is encountered.
> Instead, I would like to propose the adoption of (c), and have it
> extends a well-known, fixed value for unsupported algorithms. Secure
> Launch can leverage the fact that the TPM driver's extend function
> already expects to be given digests for all active algorithms.
> Therefore, it will record the well-known value, 0x01 to follow the ACM,
> into the digest buffers of any algorithms that Secure Launch does not
> support. This will result in the well-known value being extended each
> time a measurement is recorded. This will not be a problem as no one
> should be using those banks for attestation and can ignore those digests
> in the event log.

This seems to be at least not terrible.

Or I suppose one could use TPM_HASH_ functions? The spec for them is
somewhat impenetrable to me.

>
> I would like to note that we made a conscious design decision early on
> to use the PCR performance policy approach. We weighed a variety of
> security concerns, hardware availability, and the practicality of
> integrating the capability into our respective efforts. I do not want
> you to feel as though we are not taking your comments seriously. Ross
> reached out to some their contacts, and I reached out to a colleague
> with domain experience as well. From a cursory review, no one saw an
> issue from a crypto standpoint, beyond some algorithm recommendations.
> As we highlighted, they did caution about the resulting unorthodox
> measurement that would impose a burden on attestation solutions.
>
> Hopefully With the background and context presented, you would agree the
> above is a reasonable approach. If you do have concerns, please let us kn=
ow.
>
> V/r,
> Daniel P. Smith



--=20
Andy Lutomirski
AMA Capital Management, LLC
