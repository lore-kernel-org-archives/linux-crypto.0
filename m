Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C95361FCF;
	Sun, 22 Sep 2024 11:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727004236; cv=none; b=eFbYtMGBnaxBrjtO2Kp2CYJ4cuGWFFZr+1YfdMsmoPUM1Mq8DeYRjgMQbOkjlZR1wsIr0UUNxbcW5CG/PQ9/DRCRMCb5RbTpMr4iJklLUmh0QKBe321Sr+Q+JYhB+kxIWFS54InNNFWn0rLf7UB4bq7vz4akjyeZkgz7LkUU87I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727004236; c=relaxed/simple;
	bh=FnfCHbcu0VktafwVvmbAuuOLXZtPUKbqNqO0EhAL5do=;
	h=Message-ID:Date:MIME-Version:To:References:From:Cc:Subject:
	 In-Reply-To:Content-Type; b=chZugG3WFzc6BOPOm9xu4a2d+tG/yRg9hEaktP/syfcEEJesqBlrz1JFuwJUClNQqcTWLO+m01EgQeCV3v9Cmw3QNRA+hk4DkzqVursf/5TiPQgnqBRm/v4lnNtQ64z6FbdoArggam4Pwhcgp3Hj0ih9sMTB1u0YvfphsKMUd3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=f14SvpaG; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="f14SvpaG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1727004223;
	bh=WzGBEj5rLDAOxzJMx/5NRNI4fM2/DDlSZKliKT7Vmps=;
	h=Message-ID:Date:MIME-Version:To:From:Subject;
	b=f14SvpaG1wACvjC61ej73p+1rJdWjPMGYFLGA42yTkjwKfhWDDJOvN3Nne8EQrcTG
	 7ZM1YamDI7TyztpN2/5tCYF7l/ItfQa+AYawwAz5d4OvnHCnBivoiuDh1uE9QHIKfC
	 1n81tkNwVm7LDQX1flxff8X9LDm7LCNRchoMd7/s=
X-QQ-mid: bizesmtpip3t1727004219t6mcbvb
X-QQ-Originating-IP: lFUpJqlX0HkNmRWGS1UUXNm6byHW6DBQXHmep9drrMw=
Received: from [IPV6:240e:36c:d18:fa00:e9bb:21 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 22 Sep 2024 19:23:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 18433416527396249463
Message-ID: <FAD000B9FEA4D995+64bdb13a-3a7e-4e9f-bc15-199f8bbeae06@uniontech.com>
Date: Sun, 22 Sep 2024 19:23:37 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
To: WangYuli <wangyuli@uniontech.com>, giovanni.cabiddu@intel.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, jie.wang@intel.com,
 dong.xie@intel.com
References: <7BF34BF48048052E+20240922111832.441807-1-wangyuli@uniontech.com>
From: WangYuli <wangyuli@uniontech.com>
Content-Language: en-US
Autocrypt: addr=wangyuli@uniontech.com; keydata=
 xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSKP+nX39DN
 IVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAxFiEEa1GMzYeuKPkg
 qDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMBAAAKCRDF2h8wRvQL7g0UAQCH
 3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfPbwD/SrncJwwPAL4GiLPEC4XssV6FPUAY
 0rA68eNNI9cJLArOOARmgSyJEgorBgEEAZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7
 VTL0dvPDofBTjFYDAQgHwngEGBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIb
 DAAKCRDF2h8wRvQL7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkU
 o9ERi7qS/hbUdUgtitI89efbY0TVetgDsyeQiwU=
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, bo.cui@intel.com, bruce.w.allan@intel.com,
 karen.xiang@intel.com, pingchaox.yang@intel.com
Subject: [PATCH 1/3] crypto: qat - Correct the typo 'accelaration'
In-Reply-To: <7BF34BF48048052E+20240922111832.441807-1-wangyuli@uniontech.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------N54MKCwh0mjNCkzcTrUB7CFc"
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------N54MKCwh0mjNCkzcTrUB7CFc
Content-Type: multipart/mixed; boundary="------------s2eprH29of7FdOnA0Bmc2tyK";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: WangYuli <wangyuli@uniontech.com>, giovanni.cabiddu@intel.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, jie.wang@intel.com,
 dong.xie@intel.com
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, bo.cui@intel.com, bruce.w.allan@intel.com,
 karen.xiang@intel.com, pingchaox.yang@intel.com
Message-ID: <64bdb13a-3a7e-4e9f-bc15-199f8bbeae06@uniontech.com>
Subject: [PATCH 1/3] crypto: qat - Correct the typo 'accelaration'
References: <7BF34BF48048052E+20240922111832.441807-1-wangyuli@uniontech.com>
In-Reply-To: <7BF34BF48048052E+20240922111832.441807-1-wangyuli@uniontech.com>

--------------s2eprH29of7FdOnA0Bmc2tyK
Content-Type: multipart/mixed; boundary="------------ltEb4yjOEu066Yq7G0UMrII6"

--------------ltEb4yjOEu066Yq7G0UMrII6
Content-Type: multipart/alternative;
 boundary="------------470QXHLaUu5KS0KPNnWVybgS"

--------------470QXHLaUu5KS0KPNnWVybgS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

IEZyb20gZjUzNWRiMmQyYTMzMjc4ZGE5Mjg3NjdhMTQwZGQwZWQyYWRiOGZkZSBNb24gU2Vw
IDE3IDAwOjAwOjAwIDIwMDEgDQpGcm9tOiBXYW5nWXVsaSA8d2FuZ3l1bGlAdW5pb250ZWNo
LmNvbT4gRGF0ZTogU3VuLCAyMiBTZXAgMjAyNCAxODo0MTozNiANCiswODAwIFN1YmplY3Q6
IFtQQVRDSCAxLzNdIGNyeXB0bzogcWF0IC0gQ29ycmVjdCB0aGUgdHlwbyAnYWNjZWxhcmF0
aW9uJyANClRoZXJlIGlzIGEgc3BlbGxpbmcgbWlzdGFrZSBvZiAnYWNjZWxhcmF0aW9uJyB3
aGljaCBzaG91bGQgYmUgDQonYWNjZWxlcmF0aW9uJy4gU2lnbmVkLW9mZi1ieTogV2FuZ1l1
bGkgPHdhbmd5dWxpQHVuaW9udGVjaC5jb20+IC0tLSANCmRyaXZlcnMvY3J5cHRvL2ludGVs
L3FhdC9xYXRfY29tbW9uL3FhdF9oYWwuYyB8IDIgKy0gMSBmaWxlIGNoYW5nZWQsIDEgDQpp
bnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkgZGlmZiAtLWdpdCANCmEvZHJpdmVycy9jcnlw
dG8vaW50ZWwvcWF0L3FhdF9jb21tb24vcWF0X2hhbC5jIA0KYi9kcml2ZXJzL2NyeXB0by9p
bnRlbC9xYXQvcWF0X2NvbW1vbi9xYXRfaGFsLmMgaW5kZXggDQozMTdjYWZhOWQxMWYuLmVm
OGE5Y2Y3NGYwYyAxMDA2NDQgLS0tIA0KYS9kcml2ZXJzL2NyeXB0by9pbnRlbC9xYXQvcWF0
X2NvbW1vbi9xYXRfaGFsLmMgKysrIA0KYi9kcml2ZXJzL2NyeXB0by9pbnRlbC9xYXQvcWF0
X2NvbW1vbi9xYXRfaGFsLmMgQEAgLTE2Myw3ICsxNjMsNyBAQCBpbnQgDQpxYXRfaGFsX3Nl
dF9hZV9jdHhfbW9kZShzdHJ1Y3QgaWNwX3FhdF9md19sb2FkZXJfaGFuZGxlICpoYW5kbGUs
IHJldHVybiANCi1FSU5WQUw7IH0gLSAvKiBTZXRzIHRoZSBhY2NlbGFyYXRpb24gZW5naW5l
IGNvbnRleHQgbW9kZSB0byBlaXRoZXIgZm91ciANCm9yIGVpZ2h0ICovICsgLyogU2V0cyB0
aGUgYWNjZWxlcmF0aW9uIGVuZ2luZSBjb250ZXh0IG1vZGUgdG8gZWl0aGVyIA0KZm91ciBv
ciBlaWdodCAqLyBjc3IgPSBxYXRfaGFsX3JkX2FlX2NzcihoYW5kbGUsIGFlLCBDVFhfRU5B
QkxFUyk7IGNzciA9IA0KSUdOT1JFX1cxQ19NQVNLICYgY3NyOyBuZXdfY3NyID0gKG1vZGUg
PT0gNCkgPyAtLSAyLjQzLjANCg0K
--------------470QXHLaUu5KS0KPNnWVybgS
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF=
-8">
  </head>
  <body>
    <p><span style=3D"white-space: pre-wrap">From f535db2d2a33278da928767=
a140dd0ed2adb8fde Mon Sep 17 00:00:00 2001
From: WangYuli <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:wangyuli=
@uniontech.com">&lt;wangyuli@uniontech.com&gt;</a>
Date: Sun, 22 Sep 2024 18:41:36 +0800
Subject: [PATCH 1/3] crypto: qat - Correct the typo 'accelaration'

There is a spelling mistake of 'accelaration' which should be
'acceleration'.

Signed-off-by: WangYuli <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto=
:wangyuli@uniontech.com">&lt;wangyuli@uniontech.com&gt;</a>
---
 drivers/crypto/intel/qat/qat_common/qat_hal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_hal.c b/drivers/cryp=
to/intel/qat/qat_common/qat_hal.c
index 317cafa9d11f..ef8a9cf74f0c 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_hal.c
@@ -163,7 +163,7 @@ int qat_hal_set_ae_ctx_mode(struct icp_qat_fw_loader_=
handle *handle,
                return -EINVAL;
        }
=20
-       /* Sets the accelaration engine context mode to either four or ei=
ght */
+       /* Sets the acceleration engine context mode to either four or ei=
ght */
        csr =3D qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES);
        csr =3D IGNORE_W1C_MASK &amp; csr;
        new_csr =3D (mode =3D=3D 4) ?
--=20
2.43.0</span></p>
  </body>
</html>

--------------470QXHLaUu5KS0KPNnWVybgS--

--------------ltEb4yjOEu066Yq7G0UMrII6
Content-Type: application/pgp-keys; name="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Disposition: attachment; filename="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSK
P+nX39DNIVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAx
FiEEa1GMzYeuKPkgqDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMB
AAAKCRDF2h8wRvQL7g0UAQCH3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfP
bwD/SrncJwwPAL4GiLPEC4XssV6FPUAY0rA68eNNI9cJLArOOARmgSyJEgorBgEE
AZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7VTL0dvPDofBTjFYDAQgHwngE
GBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIbDAAKCRDF2h8wRvQL
7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkUo9ERi7qS
/hbUdUgtitI89efbY0TVetgDsyeQiwU=3D
=3DBlkq
-----END PGP PUBLIC KEY BLOCK-----

--------------ltEb4yjOEu066Yq7G0UMrII6--

--------------s2eprH29of7FdOnA0Bmc2tyK--

--------------N54MKCwh0mjNCkzcTrUB7CFc
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZu/+OQUDAAAAAAAKCRDF2h8wRvQL7g3B
AP0by1wcvNOq4DOqWsYYiVNiZREA7ZFvXn6mLpYXBVVeKQD/bfxyg8Auci683/bStkQgsFnIXTtK
FlGfwNedrgAjTgc=
=Nljl
-----END PGP SIGNATURE-----

--------------N54MKCwh0mjNCkzcTrUB7CFc--
