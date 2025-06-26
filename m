Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570D01DF739;
	Thu, 26 Jun 2025 18:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750962992; cv=none; b=Zi6UG3C1cHN6Z4usWWDrmAAvsmyVv/zJ0KrK+90WtXzkgwDmTbxM5LoXLw1gSbVT62zcUJY9Pk2WHhsF1hI0JLkR063jGdgehi4FWvznQrfo0uPe06OCap5uWxv51NSTdABQqRrzchFhMbU8BckSLfOmv8wvl64PfnAjBq6gkbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750962992; c=relaxed/simple;
	bh=mMb2J4m7KvnuNGDhzDQSaVbJO7alIlH105W3L35ZJsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5JbF8YUFg03ienfkktb81kdPMizip9in6Q+uEJCvH5q0fSYUpgc2bwsIw/sXirUfbsLNjdkUsfr3H5LOiCC6cSEZl3WK0u/6VIWy7BJULYfi0F6GLyY4pRfQLAcP0/MGSxYEPLNISSaS/fhtkyHQgqGqKFSxSIHJoH2zjh6bCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PxjukYOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PxjukYOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D06C4CEEB;
	Thu, 26 Jun 2025 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750962991;
	bh=mMb2J4m7KvnuNGDhzDQSaVbJO7alIlH105W3L35ZJsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PxjukYOL+UB+eUzBlJPVqMG7sf0+tcrt9VfHCoPoNHA0+9AMcKVJnFTDXbLpOIUIq
	 h2DAY/FrHOKVS+rHJuO930PHe1N9u59XA/LWhYXJTHh0R3xKc0K1BzSlWbxEnba2OD
	 7J85bdbJcGAjn1R+eJCAt5+lxxLPGd6EaV0R4KeOpFRIuVtgvc8r5s3zuypCwH0Wrd
	 yDpDocp4nODNMtQEr+i8EnfjC2mUV/71YZlFDQk9m0Qo/z6nvS5RfPkt0ZACOzQQAP
	 yfp/WXVcvwXgLVVZhMY3Lw99eH6HMC+y/XaUrt2A5x1LdsaBfKncr4RUlE/ZXq73Yv
	 KynwB5MUiMAAg==
Date: Thu, 26 Jun 2025 11:35:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH v5 0/2] Add support for Texas Instruments DTHE V2 crypto
 accelerator
Message-ID: <20250626183555.GB1207@sol>
References: <20250603124217.957116-1-t-pratham@ti.com>
 <20250617042755.GG8289@sol>
 <87ikktgx57.fsf@kamlesh.mail-host-address-is-not-set>
 <20250618175847.GA1639822@google.com>
 <8734bmsk3i.fsf@kamlesh.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734bmsk3i.fsf@kamlesh.mail-host-address-is-not-set>

On Thu, Jun 26, 2025 at 07:03:53PM +0530, Kamlesh Gurudasani wrote:
> Eric Biggers <ebiggers@kernel.org> writes:
> 
> >
> > Okay, so you admit that your "accelerator" is much slower than the CPU.  So (1)
> > does not apply.
> >
> > As for (2), it's not clear that applies here.  Sure, your AES engine *by itself*
> > may be more power-efficient than the AES instructions on the CPU.  However,
> > using the offload requires all the additional work associated with offloading
> > the operation from the CPU.  Since it's much slower, it will also cause the
> > operation to be dragged out over much a longer period of time, keeping the
> > system awake for longer when it could have gone into suspend earlier.
> >
> > Thus, using the "accelerator" could actually increase power usage.
> >
> > As for (3), a couple issues.  First, you're just making an argument from
> > generalities and are not claiming that it's actually true in this case.  ARMv8
> > CE instructions are in fact constant time.
> >
> > Sure, ARMv8 CE is generally not hardened against power analysis attacks.  But
> > you haven't actually claimed that your crypto engine is either.
> 1. AES/PKE engine inside DTHEv2 is DPA and EMA resistant.
> >
> > Second, these side channels, especially the ones other than timing, just aren't
> > part of the threat model of most users.
> 2. Certification like SESIP, PSA and
> IEC62443(being certified for CIP kernel- LFX [1])
> All these have requirements for sidechannel attacks resistance.(check
> lvl 3+)
> Most of our users have these requirements and they don't even care about
> performance in terms of speed.
> 
> >
> > Meanwhile, a security issue we do have is that the hardware drivers tend not to
> > be tested before the kernel is released, and often are released in a broken
> > state where they don't even do the en/decryption correctly.  Furthermore,
> > unprivileged userspace programs may use AF_ALG to exploit buggy drivers.
> 3. We have devices in kerneCI and we have regular testing and engineers
> working on acceleratprs internally too, we can be more careful about
> that these drivers are going through prescribed testing for all
> revisions.
> 
> We can reduce the prority for hw Accelerator by default if that's what
> you're trying to imply and let users decide.
> >
> > It seems implausible that this patch is more helpful than harmful.
> >
> I don't understand why you call it harmful when it is providing the
> security against side channel attacks.
> 
> If ARM itself prescribing to use crypto acclerators if they are
> avialable, then it is beyond my understanding why would you push towards
> using CE extensions.[3]
> 
> Are we not serious about the security than the performance itself?
> 
> For us,
> Point 1 and 2 is at top priority and being a SOC vendor we want to make
> sure that we provide all support that is needed by end customers for
> their threat modeling.  

If this is the motivation, then maybe it should be presented as the motivation?
Let's look at the patchset itself:

    "Add support for Texas Instruments DTHE V2 crypto accelerator"

    "This series adds support for TI DTHE V2 crypto accelerator. DTHE V2 is a
    new crypto accelerator which contains multiple crypto IPs [1].  This series
    implements support for ECB and CBC modes of AES for the AES Engine of the
    DTHE, using skcipher APIs of the kernel."

    config CRYPTO_DEV_TI_DTHEV2
        tristate "Support for TI DTHE V2 crypto accelerators"
        depends on CRYPTO && CRYPTO_HW && ARCH_K3
        select CRYPTO_ENGINE
        select CRYPTO_SKCIPHER
        select CRYPTO_ECB
        select CRYPTO_CBC
        help
          This enables support for the TI DTHE V2 hw crypto accelerator
          which can be found on TI K3 SOCs. Selecting this enables use
          of hardware acceleration for cryptographic algorithms on
          these devices.

Nothing about side channel resistance, but everything about it being an
"accelerator" and providing "hardware acceleration".  That implies that
performance is the primary motivation.

(Also, nothing about any actual use case like dm-crypt...)

If your crypto engine does indeed provide additional side channel resistance
beyond that of ARMv8 CE, and you have an actual use case where that provides a
meaningful benefit, that's potentially valuable.

Of course, it has to be weighed against the fact that these sorts of crypto
engines are problematic in pretty much every other way.  Besides actually being
slower than the CPU, they also they often have bugs/issues where they produce
the wrong output or corrupt data.  Getting those things right should be the
first priority.  Yes, you'll vouch for your driver, but so does everyone else,
and yet they actually still have these issues.  Unfortunately the odds are kind
of stacked against you; these drivers are really hard to get right.  And the
crypto self-tests don't even properly test them.

As I mentioned, these drivers also exacerbate the usual issues we have with
kernel security, where userspace programs can exploit kernel bugs to escalate
privileges.  This is because they're all accessible to userspace via AF_ALG.

Anyway, if this is supported at all, it should be opt-in at runtime.  So yes,
please decrease the cra_priority that you're registering the algorithms with.

> For embedded systems, resource utilization is also very important,
> I can use crypto accelerator and save CPU for other activities

For the small message sizes that get used in practice this doesn't seem very
plausible, especially when the alternative is ARMv8 CE.  The driver overhead and
scheduling overhead is just too much on small message sizes.

> But lets look at numbers, They are not 50x worse as you have mentioned in
> earlier mail, they are just 2x bad. These a system with one core cpu
> 833Mhz and DTHEv2 at 400Mhz
> 
> root@am62lxx-evm:~# cryptsetup benchmark --cipher aes-cbc
> cryptsetup benchmark --cipher aes-cbc
> # Tests are approximate using memory only (no storage IO).
> # Algorithm |       Key |      Encryption |      Decryption
>     aes-cbc        256b        77.7 MiB/s        77.5 MiB/s
> root@am62lxx-evm:~# modprobe -r dthev2
> modprobe -r dthev2
> root@am62lxx-evm:~# cryptsetup benchmark --cipher aes-cbc
> cryptsetup benchmark --cipher aes-cbc
> # Tests are approximate using memory only (no storage IO).
> # Algorithm |       Key |      Encryption |      Decryption
>     aes-cbc        256b       150.4 MiB/s       163.8 MiB/s
> 
> [1]https://dashboard.kernelci.org/hardware?hs=ti
> [2]https://www.cip-project.org/about/security-iec-62443-4-2
> [3]https://www.trustedfirmware.org/docs/Introduction_to_Physical_protection_for_MCU_developers_final.pdf

I'm afraid 'cryptsetup benchmark --cipher aes-cbc' is not at all the right
benchmark to use here, and it's quite misleading here:

- 'cryptsetup benchmark' uses a 64 KiB message size by default.  That's 16 times
  longer than the messages that dm-crypt typically uses.  The longer messages
  strongly skew the numbers towards the hardware crypto engine.

- 'cryptsetup benchmark' uses AF_ALG and measures not just the crypto
  performance but also the overhead of AF_ALG.  This has the effect of
  diminishing any difference in speeds.  The real difference is larger.

- You benchmarked AES-CBC, which is outdated for storage encryption.  AES-XTS is
  generally the better choice, and it's faster than AES-CBC on the CPU.
  Presumably you chose AES-CBC because your driver does not support AES-XTS.

With an 833 MHz CPU, I don't think you'll see 50x worse like I saw on some other
boards.  However, the real difference will be more than the 2x worse you're
seeing with 'cryptsetup benchmark --cipher aes-cbc'.  A more accurate benchmark
would be to do an in-kernel benchmark with 4 KiB messages, of AES-XTS (ARMv8 CE)
vs either AES-CBC-ESSIV with the AES-CBC component offloaded to your crypto
engine or AES-XTS with the AES-ECB component offloaded.

- Eric
