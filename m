Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E30D148838
	for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2024 11:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.216
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729769190; cv=pass; b=kDQFUu+OugPbSNuBiS2cskkXeKlndo2149J2788g/wmCwJ/xuHxLJfFO2AnI56i5E51zLewIOxx7nq8B4+2Y9MS9faSYZBxvZZh4flnlAPZGga+0m/TFyaqsQRc/g5etHjcyV6Be2azD7xD2qrHyuLlOEB6so1mqimW4c006m8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729769190; c=relaxed/simple;
	bh=p1EaWpi3CuDkwQ0Dy9SAS0HtKqLDe+ChTjMQlbr2Ods=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FVmBbhznSNzuT4r658uuZhf1jyIioVCWOPM1xtQDAgAaS7ComxL+uBhEjfbx+kAheLlEeiRay/pJCyoFIC5k3voymmv9i/4N5bMzZusx/3yMrMoXRtVkgdxbHA+vS3mfIpOSvEggsiJ8aSqKgbjell4SDz+3K1e5+hkWtIAZR/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=ts4HMNtd; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=ESSI9KoC; arc=pass smtp.client-ip=81.169.146.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="ts4HMNtd";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="ESSI9KoC"
ARC-Seal: i=1; a=rsa-sha256; t=1729768997; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=FVsexFMFQQ3M9ZzD7KcxCT2g0pOMZM4QfamzieZvtBYsl6CRmo7k56/RTPHB7UoA4D
    s0HoJCzVO14ru8mXDRV2LPZdFknehoYqIsIQNg1t+lnRlGH2HTZv2v1Ewxfv22qzOmac
    Lpdpidhl/9YGi/StMJFchDYCfuiXbt+zUhseJKeRBnWf1L1RjRiA9Hkhc5zLndD8/DrS
    d4JInqaasmd3XAMKTdY9Kf330CUxTT4EDnYCAMBy+u071VUdRxgayd7tpkrE6GO8eKgA
    xVU8MyBfvWAh7hLQIakiB0KociN7CMTzLiQVCqN/35fO1GVHJHKJJopLdsbMoxZx+kGh
    YZPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1729768997;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=QMWkP6W32uR0jaZzulV3f7mrNjJ7NNhNGM6tRTeZUbk=;
    b=tIjBoOcpjbnnbEFmCxRVjHEu07pp1ya++z1uiOJ6//N6OrZFxLDrgxfDIz56GH0kvl
    9s871eTJ4kmvaoKMgYh381ANliMxptFkBK33kj/4e9avBqK6kBhkoSylIbidYzGOHZYu
    am2WjK64y5kft/LSqH25fs/sMwiywdcXIpvyaYGZCWhl3EMoeKigN01tEt88gbcBbLjC
    05UoLsNRtl6bPOqM3taqkRScIcvLbP9vc4PyISmJn4YkVC5jT/fXv7MhZHRksoOQfuip
    7SWHMjojJgGjDtvL51Wcv+ZRyYE6ReVfoHC0+H9IID+KZTib20hV4lBB2460q/jysQCg
    K2HA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1729768997;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=QMWkP6W32uR0jaZzulV3f7mrNjJ7NNhNGM6tRTeZUbk=;
    b=ts4HMNtdtocPyQ64gSjSq0FdIADH98PNDNRE6RhTHwWkQ3KiX8fAxMvi97edVoqUP6
    P8RRdmuG+DChjoRjONMREJVBsu9NNMYkjAW02k5Hg4KwS5YZ/0wKzOGhOFrpzwjQFHIA
    cxZFy9AVi7mE85gy+c0nYK6zOvk+87SdA1UiLo9IzFcR6vCeSVW/N8lIJ/8wkcXfAYQa
    LrxuzZsh8yCPDUXnDllUR2jWs86TdmJEH12DXvonN5li+7yrzRsUZL/aF6128uDMwXj8
    xaRH9ARFayuWWTHrIC8nhBOiSKZsw0Wsp9CWDwNDrUCn2Tlt7Mn1TIFDkQNOBCxlyEap
    VgRg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1729768997;
    s=strato-dkim-0003; d=chronox.de;
    h=Message-ID:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=QMWkP6W32uR0jaZzulV3f7mrNjJ7NNhNGM6tRTeZUbk=;
    b=ESSI9KoC5ez567v6ONidpRRW35w1ihpsxATl53U3Ys7CuKPSflMbF/LX68adBLZnUC
    M6r28ZT/5ZulA8+cnKCQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zW4DNhHgExWlYfvSwlZFlMSaimJUAT0spKpRQdQXW56a6R9+eQ=="
Received: from tauon.atsec.com
    by smtp.strato.de (RZmta 51.2.11 AUTH)
    with ESMTPSA id f9f42509OBNHuAz
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate)
    for <linux-crypto@vger.kernel.org>;
    Thu, 24 Oct 2024 13:23:17 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: linux crypto <linux-crypto@vger.kernel.org>
Subject: Post-Quantum Algorithms for kernel crypto API
Date: Thu, 24 Oct 2024 13:23:17 +0200
Message-ID: <3469012.QNFMHsxJxX@tauon.atsec.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hi,

with the release of leancrypto 1.1.0 [1], the following PQC algorithms are 
usable in the Linux kernel:

- ML-DSA and HashML-DSA

- ML-DSA and HashML-DSA hybrid with ED25519

- SLH-DSA and HashSLH-DSA

- ML-KEM

- ML-KEM hybrid with X25519

- BIKE (round 4 KEM member)

All algorithms can be used with their native leancrypto API as well as via the 
kernel crypto API where they are usable either as akcipher for signature 
operation or as KPP.

All algorithms are offered as C implementation offer accelerations for X86, 
ARMv8 and ARMv7.

All algorithm implementations (except BIKE, which is not offered by NIST so 
far) are validated against a NIST reference implementation by obtaining CAVP 
certificates as outlined in [2]. Those certificates are also obtained for the 
in-kernel binaries of the mentioned algorithms.

See [3] for the Linux kernel support.

[1] https://leancrypto.org/leancrypto/releases/leancrypto-1.1.0/index.html

[2] https://leancrypto.org/leancrypto/cavp_certificates/index.html

[3] https://leancrypto.org/leancrypto/linux_kernel/index.html

Ciao
Stephan


