Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25FC18EAB
	for <linux-crypto@vger.kernel.org>; Tue, 14 May 2024 05:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715666254; cv=none; b=qdz7e3soQ4jLRjjEC6CrDDQ1K6oUuT5nOZAapIyIWD7zVN6V1gpVrjWs+gnT/cytagB3BJBaKr8Cx9suJdktEqKjGIVGmt7PRxea6hffytCbBX72bqn0aCtHa8jr3Zd8ilfVo5sWMgXl6kDSkp2CMRTDMLIJI46oAqWYcZ1bNRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715666254; c=relaxed/simple;
	bh=B9w4fEPi0bzs9mj1XhttzXGzZdnG8zeSAxlKzb9E1uk=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=kkl3DxbP/W6JPQ7YElAsX847Zxj/oFtDUAgrwy5sig7Jq8iZwCkcR08e4LGFOekJb6FwQGSHCepl161shq6pUuQ9JeCum84443TpdZQ5W2HISq3Oo7O+wcex2mT8cNKIUKToaVN4ThpRca92NAsLVKFitWbLjivaa46CToB0lBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=NonoZSF4; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="NonoZSF4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1715666242; x=1715925442;
	bh=BrrwFIqUOivHl/rNHoQvIfn6aSLZjaIHL6UOrmazgRo=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=NonoZSF4ZqQ/YdKSq5NC0d2+2UZ8ByN8vHnvo5LL5sL4efYpspURG6QhLlZfKjJee
	 cAKtg/tozdrpzRypowneAUa1Y4+FPxyogwLlRJK1YtVjWf7IA7ksLGJMfI6rjmsE82
	 cloTLrpyF/pzIMeJRDQzEuTH8lZPqKzqZcj9fM97aC4XSMzjMjzxQ5+JeBLFWcxtpi
	 qTuZeip99WpajktLE7N4RXrybCHDh4u1Qq8RxDRLWfR37eC2ZzO4qP/rZfPajDoX7D
	 1sLgyQXwSqolElC5ja1JrxeT28kWr7jSGvMo47v81teRjaXVYV+oYP45HybOhzHkgA
	 9ICIR5zTFqK0A==
Date: Tue, 14 May 2024 05:57:16 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Announce loop-AES-v3.8c file/swap crypto package
Message-ID: <o3EitVdfjzMQYFYoBUvjc5k5gG34HDyHO4_y8URvnISYtxVO-kLk1vkgHit-pnyFWENk6qvROkowKsaJT4_OYcCGhaUzuEv7XbwpmjU2i64=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: a05f4dae6f221e9eb043e8183b4bae4470f8cfbc
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

loop-AES changes since previous release:
- Silenced some compiler warnings.
- Added assembler AES implementation for 32/64-bit ARM for kernel patch
  version only (see kernel-arm-asm.diff). That assembler code is not in
  externally compiled module.
- Worked around kernel interface changes on 6.9 kernels.

bzip2 compressed tarball is here:

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8c.tar.bz2
    md5sum af5e33a513db272b9dfd1d252ee087d8

    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8c.tar.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

