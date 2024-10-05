Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1666231C95;
	Sat,  5 Oct 2024 06:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728109677; cv=none; b=c+bycBFkTinhonCtVCu/lPn5C9OEpCfEglB1YlwOYDsx0NobCBQAexAuljbvWjRhdml+qBR5LJo96e8WHk+cO3DUbDY54R6XWD9KztCuFN0oge5GglQMAw3sw/gG0EsM6HIPuoQTPGRGwbhQKRsDvMSjW9sKfy53dwj9tReFGXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728109677; c=relaxed/simple;
	bh=x0h55I41PNY0qDvUesT4sPVlbRExPV+X974LHXAdHVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ogc24cJmwqO2BCv6DB1TyZvi+n4FdAnlJRrTT8glIGOLmetG8bZEk/8/0iYUdJdfUsc3iNoa213EZU0qdzSd/s9ny8ghVbqT5zVuepmpwgjgqJFMpCg0jeXLk+eyl8jmpoCBg0wBuk8qbxJJIFSCOzcpH1nDzkqpZpSbKiNmoyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=s1qpVqwy; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="s1qpVqwy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1728109649; x=1728714449; i=markus.elfring@web.de;
	bh=oaWtkwikAuynprJNBCi62SYkTgrh5zdNvX/3WKywahg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=s1qpVqwytoHVAnIvLwiBn+u3aZMZaH4jo2pd+djxxbcirWWH1qEeiMFXrjzJlCPP
	 YpOYGyCMEQkwmiiV3ekyH7cWjjBKc3Vfx8NAG7EGryev0Q8mZ/+Pes30gAcI2nMmc
	 Z5DBEbAO3xBUB3kmLKOitobXfldgDme58/RWRVpF1lNNHj9tsZQmlAwNKZbymDUcM
	 VjH6uBLWhnIzhq78wRTJFd3NljzgE7oGWcPEpX60lDoi2aQ/+cym8UFoblp6Yc5Lz
	 awnr+qbwvJOZJsVQ677LT9e2JDpluZvnCX+tHPvBi2OxvOBCrqrKeUmw3uKx8QuZ3
	 2DzB0cpzV7wyahd3tw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.83.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1McZjb-1tZaw80UGr-00b7WH; Sat, 05
 Oct 2024 08:27:29 +0200
Message-ID: <9ddc71e7-e98a-4fa8-b140-4035dd2874b6@web.de>
Date: Sat, 5 Oct 2024 08:27:03 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 RESEND] crypto: lib/mpi - Extend support for scope-based
 resource management
To: linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>,
 oe-kbuild-all@lists.linux.dev
References: <bc5ce9ad-acbd-4f3b-91d6-10cf62bf5afc@web.de>
 <202409180725.ZV8DCvII-lkp@intel.com>
 <91d10516-4ba9-4fe0-8f63-86205cc4f88c@web.de>
 <ZwDPp4bU1J5uEgQe@gondor.apana.org.au>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ZwDPp4bU1J5uEgQe@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Vz8dvAyu28sIa72hBnFoF1iAvwwE2yEdeFxwWxqLcai4hwNNPwy
 JrnFOsdYZdtnmpgtXtvvUfYFCzqIHlkVp5rp339y+Uyy4zTzzZUWbOog2mqzqnQRQgPyRiD
 Q7lol7OWL0TypiE5N1zTClECTOWOuxj7Optc+/gosKNPHKqSCez91djVrHzb4ogS07IGwH5
 4kSCtLoEY1ZgRUYcv1NiQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:BG0zRRWy3as=;ZICGDu7In9yCc7MPNJpZ+qnHbQA
 Tf1caEWng+bVO8dkReRZR0c1KHfe+3trRszQsNjl2eoDbR6fGYnxJ6Y91h97DP6vRM74yg5qE
 qSqCrxnh7MTXdpr4fvPxRPYpEuDi3M57h7ukdKFF5jziotAaawOtRwn4OohfGutdjCiElZhc2
 7PHQ72ecOTqyXDLV3yGWKanbwGmXw44bFbd/P47Jsi68+i+j0Y/RRO5jC7r9+cyrnFUKJovld
 0xhmGJV5IsrZNDGvRYTfJF+UFHypQfi7cJfl6c5ATChknjUulQ2CaHSMuRl9LLen0Pz4QIHw3
 bg1DOzMDW5fvoxLYU7PJQaTaNuGJBknfX1FHCWsYKT6+eBc3z04UBLgxYl+uxWC9OwXSwu+GE
 ewfr/ejxXqBReoW9qJUbKxTO3OjaNrVNEiEF3cEht3WuZibrE08jDnKV/05As5A/YJnQUJyuf
 G32hN9EYg3j5ZG8LSEkKUzuIjIa0gEJ6BEhhOSI0PPQRLfRRomRV8sHExOKfuX0f7P+AEQHTj
 Yvd+qD0N2HhEpDXPcDJkbH7hIk0QJyGeTZCMIyQstCZLWLznTQeSVMMmSgkxsVFIC+unaWxzC
 V0l0ITi0zBPLk2cui3lfRSlC8gTnzj01FYrBg6B9HJfbrxJ9d2/IrN9ofsEP/yge0yCr12/gb
 wHCkpkGRRhL5VCas/qSqOGMwNF1B3hin2H196Q9QTLSkTlLUlV0Ft2QU05mmhJg4OyMkNIZ/J
 ZjrVbayP2GNRNX/ERKYTFKwGxQgHOHLy8kqBZ2sNSiPOPNaH+sw5+E6LzweEExVwdEqPVjKfb
 ZKGaBvWXvK0byGMFima4aSI5U7PRb2+oSu8ki7g+bbOYY=

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

V2:
The kernel build service pointed out that the proposed identifier =E2=80=
=9CT_=E2=80=9D
was not recognised by the compiler.
Thus reserved identifiers need still be applied also at such a place inste=
ad
so far.
I became curious under which circumstances corresponding development conce=
rns
will be reconsidered any more.


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
2.46.0

