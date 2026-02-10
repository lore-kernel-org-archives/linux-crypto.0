Received: from mail-43166.protonmail.ch (mail-43166.protonmail.ch [185.70.43.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B710536655F;
	Tue, 10 Feb 2026 15:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738713; cv=none; b=OGaLo7i/ahZEXgKUZ8gZ7dex6CGFn412NRdfkIIFXFtbNSRrAMw5bBdJOaw8oVGrqcdIJ5FWQ5l4nS30d7E9PoLd9SspQSHSRfySDDAQ7Uk1tDzL3wvMqPLjO63IrxBSKBuNlFc4DdtEg67ND5dczKeuL7iDspVZ6bNlxeZ2mOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738713; c=relaxed/simple;
	bh=34OFtMeiR5wUzClo47SIW6uNbMfy0kbQSz5F4kadDqU=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=QDy4Da9LfmO0VC/RSrKnyH51CEbEmbitFUxjYC25Op4pJYzfA4XFK6APj45y6kdshqJzFW1YaPaVBybZG/4CFBDgocGpxHNpOUl+uyDQyeBuziMJvLHqjyFC8axCzeVORmoyWl1lTaYcPVJOTqFFSoHmPwgDB/qn6vYNerHC4PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=RFff/hrf; arc=none smtp.client-ip=185.70.43.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="RFff/hrf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1770738709; x=1770997909;
	bh=f+OeOu6d18yS6QYGt1T/jc+J53ihviCW43RtoHdMyak=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=RFff/hrfUPe6qoHHW8PrjKXX9vir+Nl2Xi7IFKJcUGAT+g1jqYgc8B4k7R8WQ83e+
	 c9RFL5bNQoB7gzCquqkA4QL/Tv67N5CQlbNTfoTjNrLknqapD3nCia2kf+1LhWs/VU
	 6EqZJWHmHbfbPfF4K+QYlnuK6H0FZABFT+Cce6h6DA9e4PPD4KOlGORYoEfpda3cyU
	 3OBfxINDJ9RersLRfVFcgqll7tjzTMHTTTdt0FgOyWRlf7/ij93ewDvzI0T1NBVJPj
	 y0M58DtM1pJ3gWkcby6B9N1ATA7lWu+Nrkl2z66w5q66UYaR0BVMdPq0hfHLf/BQ6q
	 5F0LQ4W+r3smQ==
Date: Tue, 10 Feb 2026 15:51:45 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Announce loop-AES-v3.8h file/swap crypto package
Message-ID: <MzA2mC2MkUUoXetmgkGqYH3atXVhBP5XjUZhGXOOPUzqI2KF_L92-TfLcElaIZZAymE7ODLN3xwCbn41BmXMsilZuxPpK4zafwlcgAL-nNs=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: 83b5840e0c5b508fe9529f036a627ef1d8b2f1ef
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

loop-AES changes since previous release:
- 64-bit ARM64 AES Crypto Extension (CE) instructions
  use scoped_ksimd() on 6.19+ kernels.
=20
bzip2 compressed tarball is here:
=20
    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8h.tar.bz2
    md5sum b7e67577d3934a325fddfe06d92f6722
=20
    https://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.8h.tar.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

