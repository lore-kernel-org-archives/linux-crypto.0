Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CCE174EFC
	for <linux-crypto@vger.kernel.org>; Sat, 21 Sep 2024 22:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726958415; cv=none; b=m8RaPukSEBbhtsuBT9pg35gWMutZ9N6sIGrjl5h1XiQ+RjVjDWtCxq6nchKvvcTO5sSNOlpkFCADxg7IukkZpuz6klmsQAUfeIMOwUnyxTgq89+Ah0Ci9PnHIdOtYdOx5o1BVrScLmBYFud3X0SGKej1HKkwdIsO7Y48togRqsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726958415; c=relaxed/simple;
	bh=EbrLSVOKANzOSZo2hOV4ZpTq3Ltbi4iuLjDm1MN0uic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HbgQmfZNx/oYRPz27X2LcqhpZVT9Uz6VZmYE+rkv6C42rPMAOLtM3zB6rhwld7A588CLE/YqGkEjZYchtLlTAHR3rFnJgYaU3m6e5CkkWkIUmU/T8mV0JU8PiY89pJXDQm4B05hOGmN8KTJFbAP5LPfQweR+DaMEMpw/JRYgnro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=Ak4b8MLT; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="Ak4b8MLT"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a8a789c4fc5so714303966b.0
        for <linux-crypto@vger.kernel.org>; Sat, 21 Sep 2024 15:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1726958412; x=1727563212; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvnFCbAvrKO16MD1V3kSEfcktT7GG58Kq8nfwUeCeG8=;
        b=Ak4b8MLTBs8a+8/i0qQkiqhM5pBBohuZhYC8TqD5SbAwpvfYOz9O7/iWiEiIzqU6rU
         itEWZYs0RG1UVGY3IPwQ5n5tHq2MNyNnel5vtkVvCfreXlewCKO7dvu2y04bJRYKKcpQ
         iU20e94ZfHmviKcod/jypOHsVe+mHhzK9vMGxTRtX8xHRnammhz2vBhoC7a757JbV29t
         HQIT8jge2O7gua+YcZuHAGJToUB8zOKgzBnMdH6FkwTwyj2Vnl8bl2eakqBq0WQQ9QpM
         1ef0XXkqo3yi6Sxar9iELLQEXV307RbEUE5pCT9+RWwpCNDZoMUhjPCeLb3S6uH+bUQx
         yQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726958412; x=1727563212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvnFCbAvrKO16MD1V3kSEfcktT7GG58Kq8nfwUeCeG8=;
        b=gdWUqXlGSMwXMzkD8bVurT2wT3oMieKQqIjLD8wq3eOtlguOu+8XTW62QC9Mi084a6
         1qkdY6GEVQTriSuBRznhO2JnYoEmrP3ZUGAzUgnompDkMN2zbPw9WPQnbKPd4MXuomjS
         O/jiU5yOmR0gLRdRGz8L7SepWtaxe4cWHxxQcdWI0Gtca/lb7AgIyZ9izOGoy7kZf0My
         tHspNR0driNp9LtHb9vtxqxbKQEm67iQAXD5T0+iKpFsUr8HJNEW6gpg0pxtzEADTInY
         S6MxilkAkmGbm7m+ZMVftwHtk2J90Qpq9cFR9xJpy4YtHMDV1e+z+PM0qw2H8MGMRiQA
         qioA==
X-Forwarded-Encrypted: i=1; AJvYcCW/MqVSYJW8eBvDMXeeq48tLKxaU99QWDPHDJqGgvCc6Sr0EQObBTD0nku7hmTUvlqYSjfmFa4kQPVUjLU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg4d1eYvqF5Q4e+rEflhjzlC/zvZUvOADShhS/kylV91tgembo
	Xg6rOOoUcRuA+pfhAVzh2gBar6Ae41hdmvwTV5HX5hCr9SbTpggmEqPM1ExRqsl0x1B7O9gDa1j
	DcxDl04Z/893CMfcz3+I+3LDeMk9scMr8jhWu
X-Google-Smtp-Source: AGHT+IFaL72COl44ZtDaFEd6ElmKPYw0sykZuhkEsvikJ8ZrALW1TY8Zoa3MjMgvyB4XF620eo77HLnUVANX4vO022w=
X-Received: by 2002:a17:906:730b:b0:a8d:65f4:c7c6 with SMTP id
 a640c23a62f3a-a90c1d6ecabmr1190329166b.24.1726958411374; Sat, 21 Sep 2024
 15:40:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240531010331.134441-1-ross.philipson@oracle.com>
 <20240531010331.134441-7-ross.philipson@oracle.com> <20240531021656.GA1502@sol.localdomain>
 <874jaegk8i.fsf@email.froward.int.ebiederm.org> <5b1ce8d3-516d-4dfd-a976-38e5cee1ef4e@apertussolutions.com>
 <87ttflli09.ffs@tglx> <CALCETrXQ7rChWLDqTG0+KY7rsfajSPguMnHO1G4VJi_mgwN9Zw@mail.gmail.com>
 <1a1f0c41-70de-4f46-b91d-6dc7176893ee@apertussolutions.com>
 <8a0b59a4-a5a2-42ae-bc1c-1ddc8f2aad16@apertussolutions.com>
 <CALCETrX8caT5qvCUu24hQfxUF_wUC2XdGpS2YFP6SR++7FiM3Q@mail.gmail.com> <c466ed57-35a8-41c0-9647-c70e588ad1d3@apertussolutions.com>
In-Reply-To: <c466ed57-35a8-41c0-9647-c70e588ad1d3@apertussolutions.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 21 Sep 2024 15:40:00 -0700
Message-ID: <CALCETrW9WNNGh1dEPKfQoeU+m5q6_m97d0_bzRkZsv2LxqB_ew@mail.gmail.com>
Subject: Re: [PATCH v9 06/19] x86: Add early SHA-1 support for Secure Launch
 early measurements
To: "Daniel P. Smith" <dpsmith@apertussolutions.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Eric Biggers <ebiggers@kernel.org>, Ross Philipson <ross.philipson@oracle.com>, 
	linux-kernel@vger.kernel.org, x86@kernel.org, linux-integrity@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kexec@lists.infradead.org, linux-efi@vger.kernel.org, 
	iommu@lists.linux-foundation.org, mingo@redhat.com, bp@alien8.de, 
	hpa@zytor.com, dave.hansen@linux.intel.com, ardb@kernel.org, 
	mjg59@srcf.ucam.org, James.Bottomley@hansenpartnership.com, peterhuewe@gmx.de, 
	jarkko@kernel.org, jgg@ziepe.ca, nivedita@alum.mit.edu, 
	herbert@gondor.apana.org.au, davem@davemloft.net, corbet@lwn.net, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, kanth.ghatraju@oracle.com, 
	andrew.cooper3@citrix.com, trenchboot-devel@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 21, 2024 at 11:37=E2=80=AFAM Daniel P. Smith
<dpsmith@apertussolutions.com> wrote:
>
> On 9/13/24 23:57, Andy Lutomirski wrote:
> > On Thu, Sep 12, 2024 at 5:34=E2=80=AFPM Daniel P. Smith
> > <dpsmith@apertussolutions.com> wrote:
> >>

> > What, exactly, is your patchset doing that requires hashing at all?
> > (I assume it's extending a PCR and generating an event log entry.).
> > What, exactly, does it mean to "cap" a PCR?  How is this different
> > from what your patchset does?
>
>

...

> I did not see the term actually defined in the client profile, but the
> term "cap" refers to the specific action of hashing a value across a set
> of PCRs. This is to reflect that certain events have occurred and will
> result in a different but predictable change to the PCR value. Often
> times this is to ensure that if there are TPM objects sealed to the
> system with either that event having or have not occurred, they cannot
> be unsealed. Thus, one has "capped" the PCRs as a means to close access
> to the =E2=80=9Cacceptable=E2=80=9D system state.

Okay, so I read Ross's earlier email rather differently:

> Even if we'd prefer to use SHA-256-only, if firmware elected to start us
> with the SHA-1 and SHA-256 backs active, we still need SHA-1 to parse
> the TPM event log thus far, and deliberately cap the SHA-1 PCRs in order
> to safely use SHA-256 for everything else.

I assumed that "deliberately cap" meant that there was an actual
feature where you write something to the event log (if applicable) and
extend the PCR in a special way that *turns that PCR off*.  That is,
it does something such that later-loaded software *can't* use that PCR
to attest or unseal anything, etc.

But it sounds like you're saying that no such feature exists.  And a
quick skim of the specs doesn't come up with anything.  And the SHA1
banks may well be susceptible to a collision attack.

So what are the kernel's choices wrt the SHA-1 PCRs?  It can:

a) Perform business as usual: extend them consistently with the
SHA-256 PCRs.  This is sort of *fine*: the kernel code in question is
not relying on the security of SHA-1, but it is making it possible for
future code to (unwisely) rely on them.  (Although, if the kernel is
loading a trustworthy initramfs, then there won't be a collision, and
there is no known second-preimage attack against SHA-1.)

b) Same as (a), but with countermeasures: do something to the effect
of *detecting* the attack a la SHA1-DC and panic if an attack is
detected.  Maybe this is wise; maybe it's not.

c) Do not extend the SHA-1 PCRs and pretend they don't exist.  This
seems likely to cause massive security problems, and having the kernel
try to defend its behavior by saying "we don't support SHA-1 -- this
is a problem downstream" seems unwise to me.

d) Extend them but in an unconventional way that makes using them
extra secure.  For example, calculate SHA-256(next stage), then extend
with (next stage || "Linux thinks this is better" || SHA-256(next
stage).  This makes the SHA-1 banks usable, and it seems like it will
probably defeat anything resembling a current attack.  But maybe this
is silly.  It would probably require doing the same thing to the
SHA-256 banks for the benefit of any software that checks whether the
SHA-1 and SHA-256 banks are consistent with each other.

e) Actually try to make the SHA-1 PCRs unusable.  For example, extend
them with random numbers.

My inclination is that having some kind of Linux "policy" that SHA-1
is forbidden adds no actual security value.  Option (a) honestly seems
fine.  Nothing in the kernel *relies* on the SHA-1 hash being secure.
But option (b) also seems okay if someone is willing to put the effort
into implementing it and creating a proper test case.

But the description of all this could certainly do a better job of
explaining what's going on.

--Andy

> [1] A future expansion of Secure Launch will be to enable usage of
> Intel's Hardware Shield, link below, to provide runtime trustworthy
> determination of SMM. The full extent of this capability can only be
> achieved under a DRTM launch of the system with Intel TXT. When enabled,
> this can be used to verify the SMM protections are in place and inform
> the kernel's memory management which regions of memory are safe from SMM
> tampering.
>
> https://www.intel.com/content/dam/www/central-libraries/us/en/documents/d=
rtm-based-computing-whitepaper.pdf

Wow.  I skimmed this paper.  What an overcomplicated solution to a
problem that doesn't deserve to exist in the first place.
