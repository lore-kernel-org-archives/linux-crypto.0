Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59909267F59;
	Thu, 26 Jun 2025 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944851; cv=none; b=ZlR7BUX9mM7NC1wdDq46YeQLKYw7B/pLwb7dl8E7X3hsl6C1IW2RC2WftTDSuLeX7nJqgZaf6RrQK5FsD9vC1vPX2VvAYC6MSNUVMyrs/g4kbjB0RcJfY2HlO7CGKrjYtg4BBMvT61OV/2FxhfKAC6/p0UIfGFj/HpFGHmlrm7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944851; c=relaxed/simple;
	bh=MTfufscCs55245yA3t2uLj7ZB0URFKvgjXsaLoyy3XA=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PvvZncFwngox63vnziiXKE3EvJ+wYWApjSN7sZ0LGpKYy4gQXAdGfqrFWaKeGhxsZEzQgNiTLG52Z/tSRXNGz2XBdDfgO6GBRSPl0d7yooLGNvm1F/vEffqcBT9RJqkxLC8kxGgynxmYq0kNFEmSHUO+33ZH+PwcznNQw/5NjTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ZPVVsuOv; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ZPVVsuOv"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTP id 55QDXtJ12434115;
	Thu, 26 Jun 2025 08:33:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1750944835;
	bh=L+HNIO6gQFtowO13mUz9/yujQ4NufV5X6l/IZVQUHrw=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=ZPVVsuOvBUrnmrwQhRMGy331+A4qzclgdS0oMzNijrX83d4lvwTD5AlHuLchHsc2i
	 OHGS1iKXJPpVQHR+9NZIk9ZBYFFkziFSBBwbIW+S90f5GHoBaqsaHcLr0sxITCe9eO
	 /CMbsNCfOBt9EfCR1zFwDEnXJLMm8m+Nc//Qmhp4=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 55QDXtdQ3666006
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Thu, 26 Jun 2025 08:33:55 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Thu, 26
 Jun 2025 08:33:54 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Thu, 26 Jun 2025 08:33:55 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 55QDXsHX1076756;
	Thu, 26 Jun 2025 08:33:54 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>
Subject: Re: [PATCH v5 0/2] Add support for Texas Instruments DTHE V2 crypto
 accelerator
In-Reply-To: <20250618175847.GA1639822@google.com>
References: <20250603124217.957116-1-t-pratham@ti.com>
 <20250617042755.GG8289@sol>
 <87ikktgx57.fsf@kamlesh.mail-host-address-is-not-set>
 <20250618175847.GA1639822@google.com>
Date: Thu, 26 Jun 2025 19:03:53 +0530
Message-ID: <8734bmsk3i.fsf@kamlesh.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Eric Biggers <ebiggers@kernel.org> writes:

>
> Okay, so you admit that your "accelerator" is much slower than the CPU.  So (1)
> does not apply.
>
> As for (2), it's not clear that applies here.  Sure, your AES engine *by itself*
> may be more power-efficient than the AES instructions on the CPU.  However,
> using the offload requires all the additional work associated with offloading
> the operation from the CPU.  Since it's much slower, it will also cause the
> operation to be dragged out over much a longer period of time, keeping the
> system awake for longer when it could have gone into suspend earlier.
>
> Thus, using the "accelerator" could actually increase power usage.
>
> As for (3), a couple issues.  First, you're just making an argument from
> generalities and are not claiming that it's actually true in this case.  ARMv8
> CE instructions are in fact constant time.
>
> Sure, ARMv8 CE is generally not hardened against power analysis attacks.  But
> you haven't actually claimed that your crypto engine is either.
1. AES/PKE engine inside DTHEv2 is DPA and EMA resistant.

>
> Second, these side channels, especially the ones other than timing, just aren't
> part of the threat model of most users.
2. Certification like SESIP, PSA and
IEC62443(being certified for CIP kernel- LFX [1])
All these have requirements for sidechannel attacks resistance.(check
lvl 3+)
Most of our users have these requirements and they don't even care about
performance in terms of speed.

>
> Meanwhile, a security issue we do have is that the hardware drivers tend not to
> be tested before the kernel is released, and often are released in a broken
> state where they don't even do the en/decryption correctly.  Furthermore,
> unprivileged userspace programs may use AF_ALG to exploit buggy drivers.
3. We have devices in kerneCI and we have regular testing and engineers
working on acceleratprs internally too, we can be more careful about
that these drivers are going through prescribed testing for all
revisions.

We can reduce the prority for hw Accelerator by default if that's what
you're trying to imply and let users decide.
>
> It seems implausible that this patch is more helpful than harmful.
>
I don't understand why you call it harmful when it is providing the
security against side channel attacks.

If ARM itself prescribing to use crypto acclerators if they are
avialable, then it is beyond my understanding why would you push towards
using CE extensions.[3]

Are we not serious about the security than the performance itself?

For us,
Point 1 and 2 is at top priority and being a SOC vendor we want to make
sure that we provide all support that is needed by end customers for
their threat modeling.  

For embedded systems, resource utilization is also very important,
I can use crypto accelerator and save CPU for other activities

But lets look at numbers, They are not 50x worse as you have mentioned in
earlier mail, they are just 2x bad. These a system with one core cpu
833Mhz and DTHEv2 at 400Mhz

root@am62lxx-evm:~# cryptsetup benchmark --cipher aes-cbc
cryptsetup benchmark --cipher aes-cbc
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
    aes-cbc        256b        77.7 MiB/s        77.5 MiB/s
root@am62lxx-evm:~# modprobe -r dthev2
modprobe -r dthev2
root@am62lxx-evm:~# cryptsetup benchmark --cipher aes-cbc
cryptsetup benchmark --cipher aes-cbc
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
    aes-cbc        256b       150.4 MiB/s       163.8 MiB/s

[1]https://dashboard.kernelci.org/hardware?hs=ti
[2]https://www.cip-project.org/about/security-iec-62443-4-2
[3]https://www.trustedfirmware.org/docs/Introduction_to_Physical_protection_for_MCU_developers_final.pdf

Cheers,
Kamlesh
