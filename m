Received: from mail-24431.protonmail.ch (mail-24431.protonmail.ch [109.224.244.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A517B42C518
	for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2026 09:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787132904; cv=none; b=SGEW0IbC+TB9kJbsDKliVQ9MaLzTv35M5c5sOMEANPfZ0AKqGnpWwdVDm6ugy/flrm0xlCEQtDC6hpLxvBzTHy7YKoBuLt8ivP6vJgZSERAeqrV/JPmGvKriscuMjzzJwG8YLRLdeyO3UskGXRqmq1Qs6L9r/LGGHHk3QDkj3Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787132904; c=relaxed/simple;
	bh=zt/hSoKDw+atMOldBLRAvrdhCZet32MgWeg1I//ozRI=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=aEk7UK3+GHnu6VLU6Qc/x2yHv5xWygvLpgH1mMtPu4z6fk/LOh+0l+qDG/eAL8SOTVSYAlBeqrapyDzXyFwzQvNeEpbbBrIL1TWNrwNMi/FX4PpB7jKAQ0OdNwS+MBwkFtFIpHEuOxq++e/88JFi9cQEBI6VE/3wrbede1G69F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=V8AOsWB6; arc=none smtp.client-ip=109.224.244.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="V8AOsWB6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1787132899; x=1787392099;
	bh=+MOuRG+wZcjsga64ug0a13C9EyT7+HNTjgY69Oyi69o=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=V8AOsWB6gYQRpDGZd2kuogXETYbtkG/Ty9MXQa/d/cAaVYmhtfH/PjMXTVjiEIH/N
	 AH1QACEmpYC8UY7B+jfdpQyyVdoMRFvTCyHo7NB2+tiJBkqzTGZgOozhvjeTTV477p
	 JuJrpVovh1mHhUGItFsC50AxL+MA0/cAHv5Iec6X5NbIox9nD8gqRSX1/ayTx3GPVO
	 vDtoA58D/qG/6vdoGAUIKX3SqUjTHCNknYtzMlV8wwi3B+8jqiUMNWm/CZqBUORjx7
	 3AHsbFMnjfFvv6seseDWQRQFAgLStQYjzXGAT077RvB5Mpwq5mw22O0YDw4f0Yp4GG
	 1MikfxN2lIvQA==
Date: Wed, 19 Aug 2026 09:48:13 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Announce loop-AES-v3.8j file/swap crypto package
Message-ID: <zQTsKy7FIJ5cGOrE4ovjaRLvR4hTlFhg7mBl6nqqgy3_S1KfmquUlH_L4uaCuxzMxlijfPzWdaNCUgNvhMHVjwbW5_vaqcegK3YYpBlQ8D4=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: ffdf819d02d9f5e8ea53be7aa0a779cabdd21c95
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

loop-AES changes since previous release:
- Better fix for CVE-2026-27456 for util-linux versions 2.41.5
  and 2.42.2, earlier one in loop-AES-v3.8i was incomplete.
- Added missing #include <asm/cpuid/api.h> for 7.2 kernels.
=20
bzip2 compressed tarball is here:
=20
    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8j.tar.bz2
    md5sum bda710111a888bac6a4084e65db2a196
=20
    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8j.tar.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

