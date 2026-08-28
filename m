Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573043B14BC;
	Fri, 28 Aug 2026 10:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787912010; cv=none; b=jFIHR2qm7fsMDLcP8blduQSRnRQ2TaQvBlbhOkBayf1lAsEYtqAZ8HrrVVmBVcw7KGEOmxNOXvF85xDeu+0aZRHziFTZoXm/Kd3P99IHBjMn694JU2DPcMBa5v1bc5J8pVfoHCQNImW2b7QQNM6m9y6e9vQz77gB7WT88qZOubw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787912010; c=relaxed/simple;
	bh=MOCqXx9rCD8QzTOlsyrgHc6wGSn0GoriGkqfgj0EaOw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=J82MsTZuIGWTZX3t06KUOP8c+Y26X7vsiPvs7CNziKbN5VTpXWI/GGjDrUbDFczLgKuBIV2E1Omooy3oD+BMCUu5U9RwSYtPq2RVr0YRA0AAOXX8B4xuC54LVRrKs3P5obcRTSj4dqir8vcv25Si80qENKECOs1MTea5iMxq6Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JXhhpgKa; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JXhhpgKa"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67S6VaXj1211903;
	Fri, 28 Aug 2026 10:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IQNq+0
	07j2VAAKZ8X6a/LxI7zv4VA4+PdXV9+AulP1s=; b=JXhhpgKaqN6DqLOi14Fm6o
	+Wt1Bmk1C1qkITI3jVYBWslZcWjavy5q1jgMYENjOsdr2hoLTKWVLlLcl5MscxNp
	MnxWkfqsc8xkQqhPp+MynwCVVVNddu/LjZ+oqzaIKKaDDaHEABgrqYrF8sgOYoEo
	oxfkbbKS4Ms6k+1O2JWfykT/FG1IAFo05NFMGb89Kdv9SDQTpO9HVCJtGi4I6q1+
	KOHGIl4BAHh4ZJpCnaCfulVfE7zPUhgY1M0Co+uZjnePXfb045csOyAiwL4L0RIh
	ORCjw6Ix4X26mu7q6v9f9SpdIB4NMKJMIgzwkDhWthnGJYXNAP5BuRCpoPM1t4QQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73g5bhug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 10:13:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67SABefm018941;
	Fri, 28 Aug 2026 10:13:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7pfwnmnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 10:13:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67SAD6k039322060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Aug 2026 10:13:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CF4A2004F;
	Fri, 28 Aug 2026 10:13:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E841120049;
	Fri, 28 Aug 2026 10:13:02 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.124.215.233])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 28 Aug 2026 10:13:02 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v2] keys: reject descriptions that exceed the index length
From: Sudhakar Kuppusamy <sudhakar@linux.ibm.com>
In-Reply-To: <20260828080728.2641312-1-4ncienth@gmail.com>
Date: Fri, 28 Aug 2026 15:42:50 +0530
Cc: dhowells@redhat.com, jarkko@kernel.org, lukas@wunner.de, ignat@linux.win,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C7DCED4F-152E-4B3A-AB4D-FFBF36715168@linux.ibm.com>
References: <20260824113004.3755053-1-4ncienth@gmail.com>
 <apEWZUFe8NmwgPDb@kernel.org> <20260828053805.1410721-1-4ncienth@gmail.com>
 <20260828080728.2641312-1-4ncienth@gmail.com>
To: Daehyeon Ko <4ncienth@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: wX2JdHy-Lno6M9Jp4dVhKE739_pk7r1u
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI4MDA4NiBTYWx0ZWRfXzV2pMgZexX5C
 WmLfoQyrYcXoz2gjeFkmOUBEF3LQCTKu4pN8RQVVyISDXkjMsQHzfqr5WR3bMyq6gqnY9CPAqhU
 Z2i2BHU8/AGe0R1GCMxAWl7/PRBUDsI=
X-Proofpoint-GUID: M_JisppdUNAIZorY6gKUf2Qdt7hsmZ1r
X-Authority-Analysis: v=2.4 cv=JZyMa0KV c=1 sm=1 tr=0 ts=6a915f36 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=s105x1RxVtAys68OXUwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI4MDA4NiBTYWx0ZWRfX+lkm7GH2I35l
 h4HkA1Tyk8x2HI+8LMYODofhj27wNGjnpO/DULSct64/UmPOlBgm7BgGSl18f452o7W0uoXca1F
 zgskgSwRobU2KQkg5Z0u7RO804kMKpVoEn79OSZprLwFttifCKjovJrzoPkduJ0IYN0C/7WhQOD
 4HqLATPaxxIWeHqTxpgZXNr20Fs0KbPy/x7kFAUlXHOVRpk8LfraKGzpWDtf455ElRnQ4L4qBJc
 THyJHp5tPkBOj8MHJ3wdVdeAp27Y3Tcc9cvR7Dtqsv5aKxPhnfGeUsSQW1HPWbVacaVxRi/4qq3
 QzEHvhXLo127jV3H+ectkxrKTgcdxvzZYdWUVbfq/DReAscYH7lbaWEn7Iyt970Gr1nAV+SNY07
 JwBWfMzRCYTLdH10vXggNc5vtaymyPXn5NcZdXTOv/SKn1eq1vzjuXCk+mNAVVH8DoQBVysxPIQ
 qI+pJbJ9lbKIzD64+FQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-28_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608280086



> On 28 Aug 2026, at 1:37=E2=80=AFPM, Daehyeon Ko <4ncienth@gmail.com> =
wrote:
>=20
> struct keyring_index_key::desc_len is a u16.  User-provided key
> descriptions are limited to 4095 bytes, but a key type preparser can
> generate a longer description when the caller passes NULL.
>=20
> The X.509 parser forms a description from the certificate subject and
> twice the raw serial length when the certificate has no Subject Key
> Identifier.  A certificate with a two-byte subject and a 32766-byte =
serial
> therefore produces a 65536-byte description.  Assigning strlen() to
> desc_len wraps it to zero, after which __key_link_begin() hits:
>=20
>    BUG_ON(index_key->desc_len =3D=3D 0);
>=20
> This was reproduced through keyctl on a v6.12.105 KASAN kernel with
> panic=3D1 and oops=3Dpanic.  The process ran as uid and gid 1000 with =
no
> capabilities, and the console recorded:
>=20
>    CapInh: 0000000000000000
>    CapPrm: 0000000000000000
>    CapEff: 0000000000000000
>    [   14.044055] ------------[ cut here ]------------
>    [   14.044211] kernel BUG at security/keys/keyring.c:1308!
>    [   14.044375] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>    [   14.044558] CPU: 0 UID: 1000 PID: 138 Comm: keyctl Not tainted =
6.12.105-dirty #1
>    [   14.044788] Hardware name: QEMU Standard PC (i440FX + PIIX, =
1996), BIOS 1.15.0-1 04/01/2014
>    [   14.045025] RIP: 0010:__key_link_begin+0x1e5/0x250
>    [   14.047630] Call Trace:
>    [   14.047711]  <TASK>
>    [   14.047785]  __key_create_or_update+0x490/0xcd0
>    [   14.047954]  ? __pfx___key_create_or_update+0x10/0x10
>    [   14.048139]  ? __pfx_lookup_user_key_possessed+0x10/0x10
>    [   14.048323]  key_create_or_update+0x47/0x60
>    [   14.048484]  __do_sys_add_key+0x219/0x430
>    [   14.048632]  ? __pfx___do_sys_add_key+0x10/0x10
>    [   14.048794]  ? switch_fpu_return+0x127/0x250
>    [   14.048980]  ? srso_return_thunk+0x5/0x5f
>    [   14.049163]  ? =
arch_exit_to_user_mode_prepare.constprop.0+0x6f/0xa0
>    [   14.049417]  ? srso_return_thunk+0x5/0x5f
>    [   14.049582]  do_syscall_64+0x5a/0x130
>    [   14.049721]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    [   14.051772]  </TASK>
>    [   14.051975] ---[ end trace 0000000000000000 ]---
>    [   14.054729] Kernel panic - not syncing: Fatal exception
>=20
> The same boundary was independently reproduced on 3/3 fresh v6.12.105
> KASAN boots with the source reproducer.
>=20
> A one-byte-short control with a 32765-byte serial parsed successfully =
and
> returned EDQUOT without a splat, showing that the wrap boundary is =
causal.
>=20
> Measure generated descriptions before narrowing the length and reject
> values that cannot be represented.  On 3/3 fresh patched mainline =
KASAN
> boots, the boundary returned EINVAL and the control continued to =
return
> EDQUOT, with no BUG, Oops, KASAN report, warning or panic.
>=20
> A tested source reproducer exists and is available to maintainers
> privately.
>=20
> Fixes: f771fde82051 ("keys: Simplify key description management")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>


Reviewed-by: Sudhakar Kuppusamy <sudhakar@linux.ibm.com>


Thanks,
Sudhakar

> ---
> Changes in v2:
> - Add the observed keyctl crash trace and before/after runtime results =
to the
>  commit message.
> - Clarify that the serial is used when the certificate has no Subject =
Key
>  Identifier.
> - No code changes.
>=20
> security/keys/key.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/security/keys/key.c b/security/keys/key.c
> index b34a64d81d47ab..f2f472b45f4eee 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -14,6 +14,7 @@
> #include <linux/workqueue.h>
> #include <linux/random.h>
> #include <linux/err.h>
> +#include <linux/limits.h>
> #include "internal.h"
>=20
> struct kmem_cache *key_jar;
> @@ -820,6 +821,7 @@ static key_ref_t __key_create_or_update(key_ref_t =
keyring_ref,
> const struct cred *cred =3D current_cred();
> struct key *keyring, *key =3D NULL;
> key_ref_t key_ref;
> + size_t desc_len;
> int ret;
> struct key_restriction *restrict_link =3D NULL;
>=20
> @@ -865,7 +867,12 @@ static key_ref_t __key_create_or_update(key_ref_t =
keyring_ref,
> if (!index_key.description)
> goto error_free_prep;
> }
> - index_key.desc_len =3D strlen(index_key.description);
> + desc_len =3D strlen(index_key.description);
> + if (desc_len > U16_MAX) {
> + key_ref =3D ERR_PTR(-EINVAL);
> + goto error_free_prep;
> + }
> + index_key.desc_len =3D desc_len;
> key_set_index_key(&index_key);
>=20
> ret =3D __key_link_lock(keyring, &index_key);
>=20
> base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
> --=20
> 2.54.0
>=20

