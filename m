Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE00A11CA0;
	Sat, 12 Oct 2024 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728745563; cv=none; b=WZNrY8UyjVaJ/vV5Ppf6gSbEI2Oki2Cm0LIkdpuYwtGlcCsez0C6EuRkYirfFZMFCXfRk7nwil+x7Hu3r3GQSWT2MaxNZTpPkWUg6Ki6ihrGD6mXy8w5azDexKOEUZ1LnzYdeIkZatMw8K5CCoezLoif0n9Qr3p0dCPj7VkEdYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728745563; c=relaxed/simple;
	bh=S7tpWXAulEfXczQ3Q38hJ+twqbJoVUYqxTYPsyXWQAs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MgF5GIOhk6KtoUmHmXUEhKeGrrA4I+XfEKATHkQMBN993HBW0P6CwXDqW/GEUmBEK20gmViWmTHMGsc2kYXUO+cjkJ3jlNpCGryupG7P4WUMd9egozTma4keCYxxxaEBiO76m/tziWQkvR2Ld7xCta1xrsaXImKTwkQ8sphSBhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=mB5gCau/; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="mB5gCau/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1728745546; x=1729350346; i=markus.elfring@web.de;
	bh=+ooXuq3xV3z4uSkz3ZVk+MJfz76w0jaExrA46M+2cv0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mB5gCau/k1VhxMqmcYv/PZYNtCN2vdaUlOrNAp2UpK3D/qKpAkZsygM5BlJpPrxv
	 qaK8ynBvXwLIudN/9DUvCm9b2HfBo/u67xkO9Sefp0/wNfBvk+clD1i1jDS9e5eXz
	 SlKhyc2XiiMMfAbW0td0odw/Mo2gUjBgxo8/KmMlIQpafpzzOk930cSzwgAxMaetn
	 vx9WrTj+A06er38BfMptKertQTpyF7kkTF9zy6GH2qkjyHsGeQosfMUHf6lfEwKJZ
	 ENBvMd7/lKRCBPClFcIlEZqNuSFK9nMYWbsflHVTtoLRPFvSQNLda38CRvk/JSNZT
	 +RtdAPQ8WfNovrV9CQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.89.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MsaRt-1tnu7d2fc3-00qzpE; Sat, 12
 Oct 2024 17:05:46 +0200
Message-ID: <265021be-5349-4bda-88af-80b3796a4b88@web.de>
Date: Sat, 12 Oct 2024 17:05:44 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v3 1/3] crypto: lib/mpi - Extend support for scope-based
 resource management
From: Markus Elfring <Markus.Elfring@web.de>
To: linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <bc5ce9ad-acbd-4f3b-91d6-10cf62bf5afc@web.de>
 <202409180725.ZV8DCvII-lkp@intel.com>
 <91d10516-4ba9-4fe0-8f63-86205cc4f88c@web.de>
 <ZwDPp4bU1J5uEgQe@gondor.apana.org.au>
 <9ddc71e7-e98a-4fa8-b140-4035dd2874b6@web.de>
 <ZweTCO8cFtP_pvOu@gondor.apana.org.au>
 <ee5f409e-4412-41cd-b8d8-92872770f04d@web.de>
Content-Language: en-GB
In-Reply-To: <ee5f409e-4412-41cd-b8d8-92872770f04d@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:e/7I/RLhJfIa7NP5KTPnYC8Kqi2cfRLkbKskE2NubKjz4YbgJ6f
 R1G2FFVIS6kyL28qv6EBJpUDTGg7tZwNTMqSYcAxkyFxQloOeBTOHYHF5mDeTFW59nxN+MW
 2jXMGHF1zCQ6XHCBLOd0UDUdzhYibRrmW7w9XTd/h3kPKSPAUAzQUbin/UYsuzcp+Pd2uSD
 wayQdPB6xOFa+/+JTOrBw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dHaS+jlx2Us=;48wLR3yji6IMcPOw0nB/ENK2lgy
 caUPnTBDAK/Cj4XieFzJ+fbMGIXASzp3pBr/AZEa6fWEJATEVtA77wqHFDK41Xe52IvMcUGbi
 ECl5D5Q7A+QPQy/j19ItORRss3YUBSQDXBN6zJ1Pe36Lp6VaS06iTa88Kj5gQlVu2pJ6vmTaD
 h0p+qk5NHGeF4TFC3lwExKQDBNLIswyTiYqRcyB+K8hgB2Ibdfa2yqx47i2D7d8AL7ar0eppX
 m9ywun8TD8RdH6sH6qdm9noES9X/omFkqITAM75Jdzu399HDrvTO1HTbQZX7xoRIZox4EzGC+
 hY+a+HzvT8JFVbHUvgqEzHa5vRGzKz3EVeN7LwSk6h/VI5fkDFZaYqmjxK1CR23ACV9GQsxB0
 lEzjGn2p4U88980Q6EfTWdTekC4kLv4mQr8YOltffnvqPuj0ODyTW5qaCFhcFFJwvNKvnMDFg
 LI50eYdPw62bntLuDYv0hiwVci0zk8Qa/q4zJzXxS9KLyOG87dTh++5B+ESS9CanQEi4DiYa9
 +eUKoa1hTfcgtWzHVy9PPhISdRnqNsebKuIQnvKA3IrD2MnGTig416PDiep7DOtEh6dz1B4Qh
 85Agz/FW3ru8bLJ38GBBu1RLa3819cuu5NzLvYvWTCd5NCsD3i/E4KYn3Si1y7Cly5124aftM
 lDui95omwvwIguXK8uBbNwSjHj3Ylx40A4Cp8vJgNeuEw5TL0oXgXD35soF2qclh0ViMjcoGb
 aA8EQdwQ5p0/CsJZ0PMb5lUBj3Ed2PPWDAAqmkaELv7vc6rExWIT2esYHv13Lf+jKnoLR9lAy
 PJcchPiGbbS64I0aCQjcUIkQ==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 18 Sep 2024 11:06:35 +0200

Scope-based resource management became supported for some
programming interfaces by contributions of Peter Zijlstra on 2023-05-26.
See also the commit 54da6a0924311c7cf5015533991e44fb8eb12773 ("locking:
Introduce __cleanup() based infrastructure").

Thus add a macro call so that the attribute =E2=80=9C__free(mpi_free)=E2=
=80=9D can be
applied accordingly.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--

V3:
This suggestion was integrated into a patch series.


 include/linux/mpi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index 47be46f36435..6fbcb88ce296 100644
=2D-- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -19,6 +19,8 @@

 #include <linux/types.h>
 #include <linux/scatterlist.h>
+#include <linux/cleanup.h>
+#include <linux/err.h>

 #define BYTES_PER_MPI_LIMB	(BITS_PER_LONG / 8)
 #define BITS_PER_MPI_LIMB	BITS_PER_LONG
@@ -44,6 +46,8 @@ typedef struct gcry_mpi *MPI;
 /*-- mpiutil.c --*/
 MPI mpi_alloc(unsigned nlimbs);
 void mpi_free(MPI a);
+DEFINE_FREE(mpi_free, MPI, if (!IS_ERR_OR_NULL(_T)) mpi_free(_T))
+
 int mpi_resize(MPI a, unsigned nlimbs);

 MPI mpi_copy(MPI a);
=2D-
2.46.1

