Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356C82ED846;
	Mon, 15 Dec 2025 14:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765810792; cv=none; b=VMShuMI/sL3MQviEqkUwNeauPwQ4rSoRPP8yqdr7lkZ9pAPTORt2w+2Q5hjlcVuf0QuVM4oCEwAyFLqCffvGHYvBJKdbQqshpyc5wgKn/ZeF59fDmrkm5KLjIuDp4JaDDToUvRI8oVszpNZB8OiWYRBv9OOxD+S1neKbca6cQ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765810792; c=relaxed/simple;
	bh=mxWMAsg4dnZdP2JWi8ePdX/lmDMVNwMvqedSCSy5+AA=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BbxyoGJhhZ6QSpH1+cGTMAEsjrWARyunc5S9Dl603ucy02ooW80wQopXY9qHLo8dS5WT1chb2NQk+TV95nZybx0VDZpPUEO5AZOaTV/367RU9RWG8XqccxgJ9YKWpU4kvz5PrDaDFoRNaQ2HaA7b9GLuxlAdesb7YfejwSMea6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jryTkuWF; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jryTkuWF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765810790; x=1797346790;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=mxWMAsg4dnZdP2JWi8ePdX/lmDMVNwMvqedSCSy5+AA=;
  b=jryTkuWFsefAevopy9JBohFX1z7T79k000VgcFxjK5Q2PiOebagXJhwH
   3/Yzr0IGSjCCRjUGOckGa+h3FLeFmRaSjMAbZPLZptIFGMXfB120xPLXe
   6MK43OYR1nbxUOYJE2Bw364Wj7C2l24cC6np7RaKohiU+M/XuJqqlO202
   nCKDeWXVlWK2Q7ULahJ3Tch/1l0CEnPiPFWyFChE2X+HZ+rBIR/y74Pvt
   P8LUM/Du/84hq+SZtbcLvF+jCoQAuQPnjzeRxCw7Qa4raSZDH+roUpOKp
   XU0b/dOigJX4STQe0QApEG7nb2MS2n4sTDrYK3P5AY0XS3YRmvkhG2pUB
   A==;
X-CSE-ConnectionGUID: LJ0w4gD3RmeKajUSZxUtFA==
X-CSE-MsgGUID: YOTIgU4eRty98zsXGbyXbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="79083093"
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="79083093"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 06:59:48 -0800
X-CSE-ConnectionGUID: JxtKbZWqRYWNcPbI88hJLg==
X-CSE-MsgGUID: OJqkHxygQFCBxRXoTIRFKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="197628325"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.115])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 06:59:43 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Mon, 15 Dec 2025 16:59:37 +0200 (EET)
To: Mario Limonciello <superm1@kernel.org>
cc: Tom Lendacky <thomas.lendacky@amd.com>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, 
    Rijo Thomas <Rijo-john.Thomas@amd.com>, John Allen <john.allen@amd.com>, 
    "David S . Miller" <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>, 
    "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER" <linux-crypto@vger.kernel.org>, 
    "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>, 
    Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>
Subject: Re: [PATCH v3 5/5] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when
 PSP_CMD_TEE_RING_INIT fails
In-Reply-To: <583f8d99-22b4-45cf-a5a3-b63e99cc966e@kernel.org>
Message-ID: <d4392865-4c83-bec8-3806-8b5f6867c2a8@linux.intel.com>
References: <20251214191213.154021-1-superm1@kernel.org> <20251214191213.154021-6-superm1@kernel.org> <53f2736f-39b7-b041-ea02-372618df5de3@linux.intel.com> <583f8d99-22b4-45cf-a5a3-b63e99cc966e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1237412777-1765810777=:1225"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1237412777-1765810777=:1225
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 15 Dec 2025, Mario Limonciello wrote:

> On 12/15/25 6:01 AM, Ilpo J=C3=A4rvinen wrote:
> > On Sun, 14 Dec 2025, Mario Limonciello (AMD) wrote:
> >=20
> > > The hibernate resume sequence involves loading a resume kernel that i=
s
> > > just
> > > used for loading the hibernate image before shifting back to the exis=
ting
> > > kernel.
> > >=20
> > > During that hibernate resume sequence the resume kernel may have load=
ed
> > > the ccp driver.  If this happens the resume kernel will also have cal=
led
> > > PSP_CMD_TEE_RING_INIT but it will never have called
> > > PSP_CMD_TEE_RING_DESTROY.
> > >=20
> > > This is problematic because the existing kernel needs to re-initializ=
e the
> > > ring.  One could argue that the existing kernel should call destroy
> > > as part of restore() but there is no guarantee that the resume kernel=
 did
> > > or didn't load the ccp driver.  There is also no callback opportunity=
 for
> > > the resume kernel to destroy before handing back control to the exist=
ing
> > > kernel.
> > >=20
> > > Similar problems could potentially exist with the use of kdump and
> > > crash handling. I actually reproduced this issue like this:
> > >=20
> > > 1) rmmod ccp
> > > 2) hibernate the system
> > > 3) resume the system
> > > 4) modprobe ccp
> > >=20
> > > The resume kernel will have loaded ccp but never destroyed and then w=
hen
> > > I try to modprobe it fails.
> > >=20
> > > Because of these possible cases add a flow that checks the error code=
 from
> > > the PSP_CMD_TEE_RING_INIT call and tries to call PSP_CMD_TEE_RING_DES=
TROY
> > > if it failed.  If this succeeds then call PSP_CMD_TEE_RING_INIT again=
=2E
> > >=20
> > > Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> > > Reported-by: Lars Francke <lars.francke@gmail.com>
> > > Closes:
> > > https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7Zwzuh=
oBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> > > Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> > > ---
> > > v3:
> > >   * Add a comment (Tom)
> > >   * Add a define for busy condition (Shyam)
> > >   * Rename label (Shyam)
> > >   * Upgrade message to info (Shyam)
> > >   * Use a helper that validates result for destroy command (Shyam)
> > > ---
> > >   drivers/crypto/ccp/tee-dev.c | 12 ++++++++++++
> > >   include/linux/psp.h          |  2 ++
> > >   2 files changed, 14 insertions(+)
> > >=20
> > > diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-de=
v.c
> > > index ef1430f86ad62..9edb220abbc1a 100644
> > > --- a/drivers/crypto/ccp/tee-dev.c
> > > +++ b/drivers/crypto/ccp/tee-dev.c
> > > @@ -113,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *t=
ee)
> > >   {
> > >   =09int ring_size =3D MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ri=
ng_cmd);
> > >   =09struct tee_init_ring_cmd *cmd;
> > > +=09bool retry =3D false;
> > >   =09unsigned int reg;
> > >   =09int ret;
> > >   @@ -135,6 +136,7 @@ static int tee_init_ring(struct psp_tee_device =
*tee)
> > >   =09/* Send command buffer details to Trusted OS by writing to
> > >   =09 * CPU-PSP message registers
> > >   =09 */
> > > +retry_init:
> > >   =09ret =3D psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd=
,
> > >   =09=09=09=09  TEE_DEFAULT_CMD_TIMEOUT, &reg);
> > >   =09if (ret) {
> > > @@ -145,6 +147,16 @@ static int tee_init_ring(struct psp_tee_device *=
tee)
> > >   =09}
> > >     =09if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> > > +=09=09/*
> > > +=09=09 * During the hibernate resume sequence driver may have gotten
> > > loaded
> > > +=09=09 * but the ring not properly destroyed. If the ring doesn't
> > > work, try
> > > +=09=09 * to destroy and re-init once.
> > > +=09=09 */
> > > +=09=09if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) =3D=3D
> > > PSP_TEE_STATUS_RING_BUSY) {
> > > +=09=09=09dev_info(tee->dev, "tee: ring init command failed with
> > > busy status, retrying\n");
> > > +=09=09=09if (tee_send_destroy_cmd(tee))
> > > +=09=09=09=09goto retry_init;
> > > +=09=09}
> > >   =09=09dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n"=
,
> > >   =09=09=09FIELD_GET(PSP_CMDRESP_STS, reg));
> > >   =09=09tee_free_ring(tee);
> > > diff --git a/include/linux/psp.h b/include/linux/psp.h
> > > index 92e60aeef21e1..a329148e3684b 100644
> > > --- a/include/linux/psp.h
> > > +++ b/include/linux/psp.h
> > > @@ -23,6 +23,8 @@
> > >   #define PSP_CMDRESP_RECOVERY=09BIT(30)
> > >   #define PSP_CMDRESP_RESP=09BIT(31)
> > >   +#define PSP_TEE_STATUS_RING_BUSY 0x0000000d  /* Ring already
> > > initialized */
> >=20
> > It would be better to have this right underneath PSP_CMDRESP_STS (you
> > can use one extra space to indent different from the mask and bits).
> >=20
> > Also, there's inconsistency in STS vs STATUS in the naming.
>=20
> OK - to make sure I get it like you are suggesting for next spin, you mea=
n
> like this right?
>
> diff --git a/include/linux/psp.h b/include/linux/psp.h
> index 92e60aeef21e..b337dcce1e99 100644
> --- a/include/linux/psp.h
> +++ b/include/linux/psp.h
> @@ -18,6 +18,7 @@
>   * and should include an appropriate local definition in their source fi=
le.
>   */
>  #define PSP_CMDRESP_STS                GENMASK(15, 0)
> +#define  PSP_TEE_STS_RING_BUSY 0x0000000d  /* Ring already initialized *=
/
>  #define PSP_CMDRESP_CMD                GENMASK(23, 16)
>  #define PSP_CMDRESP_RESERVED   GENMASK(29, 24)
>  #define PSP_CMDRESP_RECOVERY   BIT(30)

Yes.

--=20
 i.

--8323328-1237412777-1765810777=:1225--
