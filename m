Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245DB15B0EE;
	Sat, 12 Oct 2024 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728745839; cv=none; b=gW5bzHW6hsUsq3o2hHaRDRpgLeaietVf3C+VV42S7qA2P65X8HsBUmzkWS4GiIWokxnqzCj2zjenTGpu3tBC26xe4e1LWxg5lrGV7YrtQCtm21cpu8zLdNHAZlFzktBfP5uTzlD9Fe1e+kEHObHkiEFeruBr67tqAtwjZnTb29I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728745839; c=relaxed/simple;
	bh=/PCxFFAaF1m//nYXUNMx5IP4iLUwwwmK+3x70nITbV8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dp+KbtCNzbdDX1aYC/7JPd7jIYxmd+oerhOsVGnprbq1hf8Gvnfoo03ionBDeibeYrO0ruJRYAWiYJh55WmxLqeUWZfj7qE78YO52lbC8vjCdPU81ns2USyoCnjCfPeZhKB15A/s+DikzIm2MGNUU2H1Z32tUqm5Tm9K+O3Wp6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Ioltwjoz; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Ioltwjoz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1728745827; x=1729350627; i=markus.elfring@web.de;
	bh=DlSdXGpy+rAqW6JENRFezwf99OG3UwW64T1E+6AzVOo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=IoltwjozG+h9OoUIB9QHJWsJU76T+QNy/VbkP+MfcQZLLyvkQ0MbEa9v1CGdCQ19
	 dxx0bXOPFnc0Q7F+N2ozzh8hwPk1TAvQJ0/bWqM6BjfLR+cP5M+5AECcyTRL8pmkq
	 z0upp8xl6garUJCxZ+odxvx4m77M6D6xwSxm8TId9KOj+g1gk/oyBHvKeC8t9R/M/
	 wusdSU3kFr4XehnQyegN0Vm/nOQRLupeamrFvcAK6PPaJ2LxciWg8F5WeWBnQxMlf
	 0lotPUsci7ULUyaZFp9fYf0y++R4n1S3Sh3wpWXFtn7PKYhCVEk041goruwTNvx24
	 hUz2HFuvuXMK6Jxgtw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.89.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mmhjw-1ti5iP04u6-00kOXY; Sat, 12
 Oct 2024 17:10:27 +0200
Message-ID: <3ac3fd6a-755e-4829-bc56-234f5b0f35e4@web.de>
Date: Sat, 12 Oct 2024 17:10:26 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v3 3/3] lib/digsig: Use scope-based resource management for
 two variables in digsig_verify_rsa()
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
X-Provags-ID: V03:K1:jy9gvAsARK9RH2Eoa6TDFRNiAGZTVdUZINJCF0Aut73t3yzNbfx
 YPizUqBxSZtKp5cwsRlYIDOswZ36BiAKEk6kU2VuuWUcBIlfzyX7Ag+2tBJyGoJNjKY+ply
 ewMbDI0yuSB6AzJ6hYpFmg/w/kDs7ajLufKPssOKVXJS+6OtVeuFEFJJbD0N4T7X+7jxpGk
 WiB9JWh6TI+pYtXJ2bPbA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:65jadcM2DZU=;PsmqeLCjJhQb18BI4XEaySKlGRZ
 qHa9koyo3WCDh+HfNrsdXHLen/InFx4lyPAETTFhRVMwj9weaTFbJOOK66/o/WDlH9UD/9Nxc
 E6SSM7IE/Yax3sBmp2BVZUxl+W3fVUF8cNxknbR4bkPoStSS9RRBnaKM+bt5C3CUo3MIQ9lEF
 5s+QCjVH+QWo8TGv7QoMzG5oX4Qri2KRfis5lznxjd+ILDkFYf5kSAJVytU0d6a5qioLrg44T
 SPQoV8p73BkymhvNfc1jk+UlRS2Mgcb8EQHL6M9lGIqNUOA5TjrK9BGsnudhNjGVYNgXU3R32
 jUNxvTmEFjKJp+kUQJ/9cBFtlZgI/LK3aEx2n+Xnm1w15QWokQb8MD9dRtOQi78lAIUYvxtlw
 TsFLLZc2GtNggUCZ6jngpmB3aBPiS3PUmXPnfYufTViqjgmYXcu6hFSyIvxT87XH3UpvLJ1MV
 sYr7X1y3hrDPjZHDaASkwiE0qU/qAETCMesi4n1FR2o1PAk2x3Zb60ttaXhaoLj2rxpcliWvX
 uYJk22XW0zJLa1nAwsZMjoUHORiPRYSM5eBmTZfd3J0zHErPUqgYKvvE/QG9aGJmDF/omjuOF
 aRoEI9xsb9+p76xAuDzhkcFhN9LMZTaSUC8zyR0Et909KwZGeJpVKO3lawz0T67CgFTTw4dPy
 W7kg4WQpI2QRo9imoCrmOs2fD5mvIxOFDdVht67vlFhLIEWMbZkZMQ9NFGXWjEDmAYeXSXKor
 zapI1i5X1sSbW/bkipmV3+Ot5wALpXs1WCd9HEpamnbPTg/iFfG7OOnP6b7j3YQ4Bh0Ct30xZ
 MNST0sXAB0VajX2RWmJS8lwA==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 12 Oct 2024 15:28:22 +0200

Scope-based resource management became supported for some
programming interfaces by contributions of Peter Zijlstra on 2023-05-26.
See also the commit 54da6a0924311c7cf5015533991e44fb8eb12773 ("locking:
Introduce __cleanup() based infrastructure").

* Thus use the attribute =E2=80=9C__free(kfree)=E2=80=9D.

* Reduce the scopes for the local variables =E2=80=9Cout1=E2=80=9D and =E2=
=80=9Cp=E2=80=9D.

* Omit explicit kfree() calls accordingly.

* Add a jump target.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--

V3:
Further adjustments were provided for the demonstration of an evolving
programming interface.


 lib/digsig.c | 87 +++++++++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 45 deletions(-)

diff --git a/lib/digsig.c b/lib/digsig.c
index 2481120094ab..1a24677af643 100644
=2D-- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -73,10 +73,9 @@ static int digsig_verify_rsa(struct key *key,
 	unsigned long mlen, mblen;
 	unsigned int l;
 	int head, i;
-	unsigned char *out1 =3D NULL;
 	const char *m;
 	MPI pkey[2];
-	uint8_t *p, *datap;
+	uint8_t *datap;
 	const uint8_t *endp;
 	const struct user_key_payload *ukp;
 	struct pubkey_hdr *pkh;
@@ -126,58 +125,56 @@ static int digsig_verify_rsa(struct key *key,
 	}

 	err =3D -ENOMEM;
-
-	out1 =3D kzalloc(mlen, GFP_KERNEL);
-	if (!out1)
-		goto free_keys;
-
 	{
-		unsigned int nret =3D siglen;
-		MPI in __free(mpi_free) =3D mpi_read_from_buffer(sig, &nret);
-
-		if (IS_ERR(in)) {
-			err =3D PTR_ERR(in);
-			goto in_exit;
-		}
+		unsigned char *out1 __free(kfree) =3D kzalloc(mlen, GFP_KERNEL);

+		if (out1)
 		{
-			MPI res __free(mpi_free) =3D mpi_alloc(mpi_get_nlimbs(in) * 2);
-
-			if (!res)
-				goto res_exit;
-
-			err =3D mpi_powm(res, in, pkey[1], pkey[0]);
-			if (err)
-				goto res_exit;
-
-			if (mpi_get_nlimbs(res) * BYTES_PER_MPI_LIMB > mlen) {
-				err =3D -EINVAL;
-				goto res_exit;
-			}
+			unsigned int nret =3D siglen;
+			MPI in __free(mpi_free) =3D mpi_read_from_buffer(sig, &nret);

-			p =3D mpi_get_buffer(res, &l, NULL);
-			if (!p) {
-				err =3D -EINVAL;
-				goto res_exit;
+			if (IS_ERR(in)) {
+				err =3D PTR_ERR(in);
+				goto in_exit;
 			}

-			len =3D mlen;
-			head =3D len - l;
-			memset(out1, 0, head);
-			memcpy(out1 + head, p, l);
-
-			kfree(p);
-
-			m =3D pkcs_1_v1_5_decode_emsa(out1, len, mblen, &len);
-
-			if (!m || len !=3D hlen || memcmp(m, h, hlen))
-				err =3D -EINVAL;
+			{
+				MPI res __free(mpi_free) =3D mpi_alloc(mpi_get_nlimbs(in) * 2);
+
+				if (!res)
+					goto res_exit;
+
+				err =3D mpi_powm(res, in, pkey[1], pkey[0]);
+				if (err)
+					goto res_exit;
+
+				if (mpi_get_nlimbs(res) * BYTES_PER_MPI_LIMB > mlen) {
+					err =3D -EINVAL;
+					goto res_exit;
+				}
+
+				{
+					uint8_t *p __free(kfree) =3D mpi_get_buffer(res, &l, NULL);
+
+					if (!p) {
+						err =3D -EINVAL;
+						goto p_exit;
+					}
+
+					len =3D mlen;
+					head =3D len - l;
+					memset(out1, 0, head);
+					memcpy(out1 + head, p, l);
+					m =3D pkcs_1_v1_5_decode_emsa(out1, len, mblen, &len);
+					if (!m || len !=3D hlen || memcmp(m, h, hlen))
+						err =3D -EINVAL;
+p_exit:
+				}
 res_exit:
-		}
+			}
 in_exit:
+		}
 	}
-
-	kfree(out1);
 free_keys:
 	while (--i >=3D 0)
 		mpi_free(pkey[i]);
=2D-
2.46.1

