Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275BB268FF4
	for <linux-crypto@vger.kernel.org>; Sat,  3 May 2025 16:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746288738; cv=none; b=RRnzM2W2md+RQxJuDwA9+jUvJfLyaXB5Rg5VlsTPfvyhQi3q/BcFQY36e0+IZ5ba6H29P8ptMyRSXe1pkRNMyuVASIeOoUxFYD7Nkn+j6rZ9Gh8NSfLn/PV2Gq4uOpGnRnxab6akxKsj6A7wbPWnG3sEILSJvA1KAWoR3wnA3S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746288738; c=relaxed/simple;
	bh=qwb3eRBQ+/X+oLnG+M7jZv490TIWZ5rvtNHtdgp5Bvk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ityaC75DZIjvSQT02kis8ft8FgpJaWz61WNR6S0CU5Cexm5tGQ1HCB+JnBpb9TloLSJgtT/gwVQbsW2+JrY1npJNpdD47aCXEjnVGrbhPArPc+Tnl02mCf4VQR6/oW2C5j4GzHiD0/+YsTdNuF4ha/tmb9z7fNvZ61YTIHVKPCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fdUTSZEv; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fdUTSZEv"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-301c4850194so2541412a91.2
        for <linux-crypto@vger.kernel.org>; Sat, 03 May 2025 09:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1746288734; x=1746893534; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DpSBgkZ6a394gMnmYZD71YJi2TqzNJEgVA/KHtq3Clk=;
        b=fdUTSZEv5sac1m+/ukxV1CMNlgdXOFzR3NdMsPUHLUvCYpLpY+V+86LGw/jWJ2ete3
         KVUD33HAbFwRh6L6jmiurENOoeko/3cpx92I9KEerGZLoZcf5o8YqEv1lW2aykXqtWY/
         PUrKUrZEgb+lp7G/tuwdCAAgJ+yQOgLDP62M0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746288734; x=1746893534;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DpSBgkZ6a394gMnmYZD71YJi2TqzNJEgVA/KHtq3Clk=;
        b=ReCxM5/bMtP0OcQGLV+Y1vZPx0THE/L/XWZWJYYEHDjymgb/ZJb7kc+Lp9qX708p7r
         LGyQGn0NxojjSx1fUMN+dYdGqohYLOjy+mG6VUN1NeCjLEd4RogX6068PapX5Qy/3Yur
         BljQ1QZ2XDiDnKVUXWELR5wyQsZtH68FCpTeGKwiNo9iHUd3kMSttBnPl+62lvJYedTC
         Ysj9W5NtLqzpaaWQfWl+PvGLgU3wX1vk0meg0JjgVqxhlqaiQ6F5VIq7+h2LbGee7B29
         wD+i2nu17q29tjmltcclY55HpQ7S36DwBlcu7gF1/fVRaeVyvQ+YUjbh4Abw+OfWpxRv
         QoSA==
X-Forwarded-Encrypted: i=1; AJvYcCWE5WC6bjO9+YGX80GbYm1l7t6Ic7eh9YyBnma0h8Ba01wFcu1U5FsIzqnmswZBd65CddXi0gNVbTaMSmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAVtxGCrssM7YuwyqVo8rU2sNq86VR9Eu2/5XyTo3bfzJaaSVM
	x/eucAk4Qfl9HmuiHNZed4rDJNm/CEERQz6EKcMwy6Uq8dF42b6Xmon7FZtqpRuqt7lsfJtKkk7
	jNFyi2xWMX2TdR3jLdG5TVsSkGsWsVyUwuM0I
X-Gm-Gg: ASbGncsTO+4Q0YWZ7l/RfhAZMJbrBR6ztrq+WW8cgrSMW1lXBLhIznCL1uMXSvni8Kp
	liKmYzh4kZLYzTMtK4wnWjO/pBYLZDgsRs5QKm/L6SIWYo1moaz4kjo8dlEdecX27Sj2OtC6C8d
	YUIFSfNephoWD+Wwlne2Im
X-Google-Smtp-Source: AGHT+IFRAHLhj3d5tVV15lgk8w2xRJFXXjwVrqEvZXcnVLO/Yyk+fj66KR4nC78fSJC48DtzRWjEjgtpAIMqqMtGqtQ=
X-Received: by 2002:a17:90b:560f:b0:2fe:ba7f:8032 with SMTP id
 98e67ed59e1d1-30a6198d089mr2445379a91.9.1746288734263; Sat, 03 May 2025
 09:12:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502132005.611698-1-tanmay@marvell.com> <20250502132005.611698-8-tanmay@marvell.com>
In-Reply-To: <20250502132005.611698-8-tanmay@marvell.com>
From: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Date: Sat, 3 May 2025 21:42:01 +0530
X-Gm-Features: ATxdqUGA_RhcvpmW7KdKtuW5h3wY3E6cVV9R9qld9VMklMWLDWdkZ-leIPNVqhw
Message-ID: <CAH-L+nOBsC7vYvXtd3f_=n60vW00pEJ12R9xABLnv-Bx7+AkpA@mail.gmail.com>
Subject: Re: [net-next PATCH v1 07/15] octeontx2-af: Add support for SPI to SA
 index translation
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, sgoutham@marvell.com, 
	lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com, 
	hkelam@marvell.com, sbhatta@marvell.com, andrew+netdev@lunn.ch, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	bbhushan2@marvell.com, bhelgaas@google.com, pstanner@redhat.com, 
	gregkh@linuxfoundation.org, peterz@infradead.org, linux@treblig.org, 
	krzysztof.kozlowski@linaro.org, giovanni.cabiddu@intel.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, rkannoth@marvell.com, sumang@marvell.com, 
	gcherian@marvell.com, Kiran Kumar K <kirankumark@marvell.com>, 
	Nithin Dabilpuram <ndabilpuram@marvell.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000b4eb2506343d87a2"

--000000000000b4eb2506343d87a2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 2, 2025 at 6:56=E2=80=AFPM Tanmay Jagdale <tanmay@marvell.com> =
wrote:
>
> From: Kiran Kumar K <kirankumark@marvell.com>
>
> In case of IPsec, the inbound SPI can be random. HW supports mapping
> SPI to an arbitrary SA index. SPI to SA index is done using a lookup
> in NPC cam entry with key as SPI, MATCH_ID, LFID. Adding Mbox API
> changes to configure the match table.
>
> Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
> Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/af/Makefile    |   2 +-
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |  27 +++
>  .../net/ethernet/marvell/octeontx2/af/rvu.c   |   4 +
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |  13 ++
>  .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   6 +
>  .../marvell/octeontx2/af/rvu_nix_spi.c        | 220 ++++++++++++++++++
>  .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   4 +
>  7 files changed, 275 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi=
.c
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers=
/net/ethernet/marvell/octeontx2/af/Makefile
> index ccea37847df8..49318017f35f 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> @@ -8,7 +8,7 @@ obj-$(CONFIG_OCTEONTX2_MBOX) +=3D rvu_mbox.o
>  obj-$(CONFIG_OCTEONTX2_AF) +=3D rvu_af.o
>
>  rvu_mbox-y :=3D mbox.o rvu_trace.o
> -rvu_af-y :=3D cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
> +rvu_af-y :=3D cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o rvu_nix_spi.o \
>                   rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o \
>                   rvu_cpt.o rvu_devlink.o rpm.o rvu_cn10k.o rvu_switch.o =
\
>                   rvu_sdp.o rvu_npc_hash.o mcs.o mcs_rvu_if.o mcs_cnf10kb=
.o \
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/n=
et/ethernet/marvell/octeontx2/af/mbox.h
> index 715efcc04c9e..5cebf10a15a7 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> @@ -326,6 +326,10 @@ M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline=
_ipsec_cfg,            \
>  M(NIX_LF_INLINE_RQ_CFG, 0x8024, nix_lf_inline_rq_cfg,          \
>                                 nix_rq_cpt_field_mask_cfg_req,  \
>                                 msg_rsp)        \
> +M(NIX_SPI_TO_SA_ADD,    0x8026, nix_spi_to_sa_add, nix_spi_to_sa_add_req=
,   \
> +                               nix_spi_to_sa_add_rsp)                   =
   \
> +M(NIX_SPI_TO_SA_DELETE, 0x8027, nix_spi_to_sa_delete, nix_spi_to_sa_dele=
te_req,   \
> +                               msg_rsp)                                 =
       \
>  M(NIX_MCAST_GRP_CREATE,        0x802b, nix_mcast_grp_create, nix_mcast_g=
rp_create_req, \
>                                 nix_mcast_grp_create_rsp)                =
       \
>  M(NIX_MCAST_GRP_DESTROY, 0x802c, nix_mcast_grp_destroy, nix_mcast_grp_de=
stroy_req,     \
> @@ -880,6 +884,29 @@ enum nix_rx_vtag0_type {
>         NIX_AF_LFX_RX_VTAG_TYPE7,
>  };
>
> +/* For SPI to SA index add */
> +struct nix_spi_to_sa_add_req {
> +       struct mbox_msghdr hdr;
> +       u32 sa_index;
> +       u32 spi_index;
> +       u16 match_id;
> +       bool valid;
> +};
> +
> +struct nix_spi_to_sa_add_rsp {
> +       struct mbox_msghdr hdr;
> +       u16 hash_index;
> +       u8 way;
> +       u8 is_duplicate;
> +};
> +
> +/* To free SPI to SA index */
> +struct nix_spi_to_sa_delete_req {
> +       struct mbox_msghdr hdr;
> +       u16 hash_index;
> +       u8 way;
> +};
> +
>  /* For NIX LF context alloc and init */
>  struct nix_lf_alloc_req {
>         struct mbox_msghdr hdr;
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/ne=
t/ethernet/marvell/octeontx2/af/rvu.c
> index ea346e59835b..2b7c09bb24e1 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> @@ -90,6 +90,9 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
>
>         if (is_rvu_npc_hash_extract_en(rvu))
>                 hw->cap.npc_hash_extract =3D true;
> +
> +       if (is_rvu_nix_spi_to_sa_en(rvu))
> +               hw->cap.spi_to_sas =3D 0x2000;
>  }
>
>  /* Poll a RVU block's register 'offset', for a 'zero'
> @@ -2723,6 +2726,7 @@ static void __rvu_flr_handler(struct rvu *rvu, u16 =
pcifunc)
>         rvu_blklf_teardown(rvu, pcifunc, BLKADDR_NPA);
>         rvu_reset_lmt_map_tbl(rvu, pcifunc);
>         rvu_detach_rsrcs(rvu, NULL, pcifunc);
> +
>         /* In scenarios where PF/VF drivers detach NIXLF without freeing =
MCAM
>          * entries, check and free the MCAM entries explicitly to avoid l=
eak.
>          * Since LF is detached use LF number as -1.
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/ne=
t/ethernet/marvell/octeontx2/af/rvu.h
> index 71407f6318ec..42fc3e762bc0 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> @@ -395,6 +395,7 @@ struct hw_cap {
>         u16     nix_txsch_per_cgx_lmac; /* Max Q's transmitting to CGX LM=
AC */
>         u16     nix_txsch_per_lbk_lmac; /* Max Q's transmitting to LBK LM=
AC */
>         u16     nix_txsch_per_sdp_lmac; /* Max Q's transmitting to SDP LM=
AC */
> +       u16     spi_to_sas; /* Num of SPI to SA index */
>         bool    nix_fixed_txschq_mapping; /* Schq mapping fixed or flexib=
le */
>         bool    nix_shaping;             /* Is shaping and coloring suppo=
rted */
>         bool    nix_shaper_toggle_wait; /* Shaping toggle needs poll/wait=
 */
> @@ -800,6 +801,17 @@ static inline bool is_rvu_npc_hash_extract_en(struct=
 rvu *rvu)
>         return true;
>  }
>
> +static inline bool is_rvu_nix_spi_to_sa_en(struct rvu *rvu)
> +{
> +       u64 nix_const2;
> +
> +       nix_const2 =3D rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_CONST2);
> +       if ((nix_const2 >> 48) & 0xffff)
> +               return true;
> +
> +       return false;
> +}
> +
>  static inline u16 rvu_nix_chan_cgx(struct rvu *rvu, u8 cgxid,
>                                    u8 lmacid, u8 chan)
>  {
> @@ -992,6 +1004,7 @@ int nix_get_struct_ptrs(struct rvu *rvu, u16 pcifunc=
,
>                         struct nix_hw **nix_hw, int *blkaddr);
>  int rvu_nix_setup_ratelimit_aggr(struct rvu *rvu, u16 pcifunc,
>                                  u16 rq_idx, u16 match_id);
> +int rvu_nix_free_spi_to_sa_table(struct rvu *rvu, uint16_t pcifunc);
>  int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
>                         struct nix_cn10k_aq_enq_req *aq_req,
>                         struct nix_cn10k_aq_enq_rsp *aq_rsp,
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/driver=
s/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> index b15fd331facf..68525bfc8e6d 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> @@ -1751,6 +1751,9 @@ int rvu_mbox_handler_nix_lf_free(struct rvu *rvu, s=
truct nix_lf_free_req *req,
>         else
>                 rvu_npc_free_mcam_entries(rvu, pcifunc, nixlf);
>
> +       /* Reset SPI to SA index table */
> +       rvu_nix_free_spi_to_sa_table(rvu, pcifunc);
> +
>         /* Free any tx vtag def entries used by this NIX LF */
>         if (!(req->flags & NIX_LF_DONT_FREE_TX_VTAG))
>                 nix_free_tx_vtag_entries(rvu, pcifunc);
> @@ -5312,6 +5315,9 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifu=
nc, int blkaddr, int nixlf)
>         nix_rx_sync(rvu, blkaddr);
>         nix_txschq_free(rvu, pcifunc);
>
> +       /* Reset SPI to SA index table */
> +       rvu_nix_free_spi_to_sa_table(rvu, pcifunc);
> +
>         clear_bit(NIXLF_INITIALIZED, &pfvf->flags);
>
>         if (is_pf_cgxmapped(rvu, pf) && rvu->rep_mode)
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c b/dr=
ivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c
> new file mode 100644
> index 000000000000..b8acc23a47bc
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c
> @@ -0,0 +1,220 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Marvell RVU Admin Function driver
> + *
> + * Copyright (C) 2022 Marvell.
Copyright year 2025?
> + *
> + */
> +
> +#include "rvu.h"
> +
> +static bool nix_spi_to_sa_index_check_duplicate(struct rvu *rvu,
> +                                               struct nix_spi_to_sa_add_=
req *req,
> +                                               struct nix_spi_to_sa_add_=
rsp *rsp,
> +                                               int blkaddr, int16_t inde=
x, u8 way,
> +                                               bool *is_valid, int lfidx=
)
> +{
> +       u32 spi_index;
> +       u16 match_id;
> +       bool valid;
> +       u8 lfid;
> +       u64 wkey;
Maintain RCT order while declaring variables
> +
> +       wkey =3D rvu_read64(rvu, blkaddr, NIX_AF_SPI_TO_SA_KEYX_WAYX(inde=
x, way));
> +       spi_index =3D (wkey & 0xFFFFFFFF);
> +       match_id =3D ((wkey >> 32) & 0xFFFF);
> +       lfid =3D ((wkey >> 48) & 0x7f);
> +       valid =3D ((wkey >> 55) & 0x1);
> +
> +       *is_valid =3D valid;
> +       if (!valid)
> +               return 0;
> +
> +       if (req->spi_index =3D=3D spi_index && req->match_id =3D=3D match=
_id &&
> +           lfidx =3D=3D lfid) {
> +               rsp->hash_index =3D index;
> +               rsp->way =3D way;
> +               rsp->is_duplicate =3D true;
> +               return 1;
> +       }
> +       return 0;
> +}
> +
> +static void  nix_spi_to_sa_index_table_update(struct rvu *rvu,
> +                                             struct nix_spi_to_sa_add_re=
q *req,
> +                                             struct nix_spi_to_sa_add_rs=
p *rsp,
> +                                             int blkaddr, int16_t index,=
 u8 way,
> +                                             int lfidx)
> +{
> +       u64 wvalue;
> +       u64 wkey;
> +
> +       wkey =3D (req->spi_index | ((u64)req->match_id << 32) |
> +               (((u64)lfidx) << 48) | ((u64)req->valid << 55));
> +       rvu_write64(rvu, blkaddr, NIX_AF_SPI_TO_SA_KEYX_WAYX(index, way),
> +                   wkey);
> +       wvalue =3D (req->sa_index & 0xFFFFFFFF);
> +       rvu_write64(rvu, blkaddr, NIX_AF_SPI_TO_SA_VALUEX_WAYX(index, way=
),
> +                   wvalue);
> +       rsp->hash_index =3D index;
> +       rsp->way =3D way;
> +       rsp->is_duplicate =3D false;
> +}
> +
> +int rvu_mbox_handler_nix_spi_to_sa_delete(struct rvu *rvu,
> +                                         struct nix_spi_to_sa_delete_req=
 *req,
> +                                         struct msg_rsp *rsp)
> +{
> +       struct rvu_hwinfo *hw =3D rvu->hw;
> +       u16 pcifunc =3D req->hdr.pcifunc;
> +       int lfidx, lfid;
> +       int blkaddr;
> +       u64 wvalue;
> +       u64 wkey;
> +       int ret =3D 0;
> +
> +       if (!hw->cap.spi_to_sas)
> +               return NIX_AF_ERR_PARAM;
> +
> +       if (!is_nixlf_attached(rvu, pcifunc)) {
> +               ret =3D NIX_AF_ERR_AF_LF_INVALID;
> +               goto exit;
there is no need of label here, you can return directly
> +       }
> +
> +       blkaddr =3D rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
> +       lfidx =3D rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
> +       if (lfidx < 0) {
> +               ret =3D NIX_AF_ERR_AF_LF_INVALID;
> +               goto exit;
there is no need of label here, you can return directly
> +       }
> +
> +       mutex_lock(&rvu->rsrc_lock);
> +
> +       wkey =3D rvu_read64(rvu, blkaddr,
> +                         NIX_AF_SPI_TO_SA_KEYX_WAYX(req->hash_index, req=
->way));
> +       lfid =3D ((wkey >> 48) & 0x7f);
It would be nice if you use macros instead of these hard coded magic
numbers. Same comment applies to whole patch series.
> +       if (lfid !=3D lfidx) {
> +               ret =3D NIX_AF_ERR_AF_LF_INVALID;
> +               goto unlock;
> +       }
> +
> +       wkey =3D 0;
> +       rvu_write64(rvu, blkaddr,
> +                   NIX_AF_SPI_TO_SA_KEYX_WAYX(req->hash_index, req->way)=
, wkey);
> +       wvalue =3D 0;
> +       rvu_write64(rvu, blkaddr,
> +                   NIX_AF_SPI_TO_SA_VALUEX_WAYX(req->hash_index, req->wa=
y), wvalue);
> +unlock:
> +       mutex_unlock(&rvu->rsrc_lock);
> +exit:
> +       return ret;
> +}
> +
> +int rvu_mbox_handler_nix_spi_to_sa_add(struct rvu *rvu,
> +                                      struct nix_spi_to_sa_add_req *req,
> +                                      struct nix_spi_to_sa_add_rsp *rsp)
> +{
> +       u16 way0_index, way1_index, way2_index, way3_index;
> +       struct rvu_hwinfo *hw =3D rvu->hw;
> +       u16 pcifunc =3D req->hdr.pcifunc;
> +       bool way0, way1, way2, way3;
> +       int ret =3D 0;
> +       int blkaddr;
> +       int lfidx;
> +       u64 value;
> +       u64 key;
> +
> +       if (!hw->cap.spi_to_sas)
> +               return NIX_AF_ERR_PARAM;
> +
> +       if (!is_nixlf_attached(rvu, pcifunc)) {
> +               ret =3D NIX_AF_ERR_AF_LF_INVALID;
> +               goto exit;
there is no need of label here, you can return directly
> +       }
> +
> +       blkaddr =3D rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
> +       lfidx =3D rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
> +       if (lfidx < 0) {
> +               ret =3D NIX_AF_ERR_AF_LF_INVALID;
> +               goto exit;
there is no need of label here, you can return directly
> +       }
> +
> +       mutex_lock(&rvu->rsrc_lock);
> +
> +       key =3D (((u64)lfidx << 48) | ((u64)req->match_id << 32) | req->s=
pi_index);
> +       rvu_write64(rvu, blkaddr, NIX_AF_SPI_TO_SA_HASH_KEY, key);
> +       value =3D rvu_read64(rvu, blkaddr, NIX_AF_SPI_TO_SA_HASH_VALUE);
> +       way0_index =3D (value & 0x7ff);
> +       way1_index =3D ((value >> 16) & 0x7ff);
> +       way2_index =3D ((value >> 32) & 0x7ff);
> +       way3_index =3D ((value >> 48) & 0x7ff);
> +
> +       /* Check for duplicate entry */
> +       if (nix_spi_to_sa_index_check_duplicate(rvu, req, rsp, blkaddr,
> +                                               way0_index, 0, &way0, lfi=
dx) ||
> +           nix_spi_to_sa_index_check_duplicate(rvu, req, rsp, blkaddr,
> +                                               way1_index, 1, &way1, lfi=
dx) ||
> +           nix_spi_to_sa_index_check_duplicate(rvu, req, rsp, blkaddr,
> +                                               way2_index, 2, &way2, lfi=
dx) ||
> +           nix_spi_to_sa_index_check_duplicate(rvu, req, rsp, blkaddr,
> +                                               way3_index, 3, &way3, lfi=
dx)) {
> +               ret =3D 0;
> +               goto unlock;
> +       }
> +
> +       /* If not present, update first available way with index */
> +       if (!way0)
> +               nix_spi_to_sa_index_table_update(rvu, req, rsp, blkaddr,
> +                                                way0_index, 0, lfidx);
> +       else if (!way1)
> +               nix_spi_to_sa_index_table_update(rvu, req, rsp, blkaddr,
> +                                                way1_index, 1, lfidx);
> +       else if (!way2)
> +               nix_spi_to_sa_index_table_update(rvu, req, rsp, blkaddr,
> +                                                way2_index, 2, lfidx);
> +       else if (!way3)
> +               nix_spi_to_sa_index_table_update(rvu, req, rsp, blkaddr,
> +                                                way3_index, 3, lfidx);
> +unlock:
> +       mutex_unlock(&rvu->rsrc_lock);
> +exit:
> +       return ret;
> +}
> +
> +int rvu_nix_free_spi_to_sa_table(struct rvu *rvu, uint16_t pcifunc)
> +{
> +       struct rvu_hwinfo *hw =3D rvu->hw;
> +       int lfidx, lfid;
> +       int index, way;
> +       u64 value, key;
Maintain RCT order here
> +       int blkaddr;
> +
> +       if (!hw->cap.spi_to_sas)
> +               return 0;
> +
> +       blkaddr =3D rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
> +       lfidx =3D rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
> +       if (lfidx < 0)
> +               return NIX_AF_ERR_AF_LF_INVALID;
> +
> +       mutex_lock(&rvu->rsrc_lock);
> +       for (index =3D 0; index < hw->cap.spi_to_sas / 4; index++) {
> +               for (way =3D 0; way < 4; way++) {
> +                       key =3D rvu_read64(rvu, blkaddr,
> +                                        NIX_AF_SPI_TO_SA_KEYX_WAYX(index=
, way));
> +                       lfid =3D ((key >> 48) & 0x7f);
> +                       if (lfid =3D=3D lfidx) {
> +                               key =3D 0;
> +                               rvu_write64(rvu, blkaddr,
> +                                           NIX_AF_SPI_TO_SA_KEYX_WAYX(in=
dex, way),
> +                                           key);
> +                               value =3D 0;
> +                               rvu_write64(rvu, blkaddr,
> +                                           NIX_AF_SPI_TO_SA_VALUEX_WAYX(=
index, way),
> +                                           value);
> +                       }
> +               }
> +       }
> +       mutex_unlock(&rvu->rsrc_lock);
> +
> +       return 0;
> +}
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/driver=
s/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> index e5e005d5d71e..b64547fe4811 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> @@ -396,6 +396,10 @@
>  #define NIX_AF_RX_CHANX_CFG(a)                  (0x1A30 | (a) << 15)
>  #define NIX_AF_CINT_TIMERX(a)                   (0x1A40 | (a) << 18)
>  #define NIX_AF_LSO_FORMATX_FIELDX(a, b)         (0x1B00 | (a) << 16 | (b=
) << 3)
> +#define NIX_AF_SPI_TO_SA_KEYX_WAYX(a, b)        (0x1C00 | (a) << 16 | (b=
) << 3)
> +#define NIX_AF_SPI_TO_SA_VALUEX_WAYX(a, b)      (0x1C40 | (a) << 16 | (b=
) << 3)
> +#define NIX_AF_SPI_TO_SA_HASH_KEY               (0x1C90)
> +#define NIX_AF_SPI_TO_SA_HASH_VALUE             (0x1CA0)
>  #define NIX_AF_LFX_CFG(a)              (0x4000 | (a) << 17)
>  #define NIX_AF_LFX_SQS_CFG(a)          (0x4020 | (a) << 17)
>  #define NIX_AF_LFX_TX_CFG2(a)          (0x4028 | (a) << 17)
> --
> 2.43.0
>
>


--=20
Regards,
Kalesh AP

--000000000000b4eb2506343d87a2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQfgYJKoZIhvcNAQcCoIIQbzCCEGsCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3iMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBWowggRSoAMCAQICDDfBRQmwNSI92mit0zANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwODI5NTZaFw0yNTA5MTAwODI5NTZaMIGi
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xHzAdBgNVBAMTFkthbGVzaCBBbmFra3VyIFB1cmF5aWwxMjAw
BgkqhkiG9w0BCQEWI2thbGVzaC1hbmFra3VyLnB1cmF5aWxAYnJvYWRjb20uY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxnv1Reaeezfr6NEmg3xZlh4cz9m7QCN13+j4z1scrX+b
JfnV8xITT5yvwdQv3R3p7nzD/t29lTRWK3wjodUd2nImo6vBaH3JbDwleIjIWhDXLNZ4u7WIXYwx
aQ8lYCdKXRsHXgGPY0+zSx9ddpqHZJlHwcvas3oKnQN9WgzZtsM7A8SJefWkNvkcOtef6bL8Ew+3
FBfXmtsPL9I2vita8gkYzunj9Nu2IM+MnsP7V/+Coy/yZDtFJHp30hDnYGzuOhJchDF9/eASvE8T
T1xqJODKM9xn5xXB1qezadfdgUs8k8QAYyP/oVBafF9uqDudL6otcBnziyDBQdFCuAQN7wIDAQAB
o4IB5DCCAeAwDgYDVR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZC
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3J0MEEGCCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3Iz
cGVyc29uYWxzaWduMmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcC
ARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNV
HR8EQjBAMD6gPKA6hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNp
Z24yY2EyMDIwLmNybDAuBgNVHREEJzAlgSNrYWxlc2gtYW5ha2t1ci5wdXJheWlsQGJyb2FkY29t
LmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGP
zzAdBgNVHQ4EFgQUI3+tdStI+ABRGSqksMsiCmO9uDAwDQYJKoZIhvcNAQELBQADggEBAGfe1o9b
4wUud0FMjb/FNdc433meL15npjdYWUeioHdlCGB5UvEaMGu71QysfoDOfUNeyO9YKp0h0fm7clvo
cBqeWe4CPv9TQbmLEtXKdEpj5kFZBGmav69mGTlu1A9KDQW3y0CDzCPG2Fdm4s73PnkwvemRk9E2
u9/kcZ8KWVeS+xq+XZ78kGTKQ6Wii3dMK/EHQhnDfidadoN/n+x2ySC8yyDNvy81BocnblQzvbuB
a30CvRuhokNO6Jzh7ZFtjKVMzYas3oo6HXgA+slRszMu4pc+fRPO41FHjeDM76e6P5OnthhnD+NY
x6xokUN65DN1bn2MkeNs0nQpizDqd0QxggJgMIICXAIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYD
VQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25h
bFNpZ24gMiBDQSAyMDIwAgw3wUUJsDUiPdpordMwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcN
AQkEMSIEIFNjiN0hIiU2UykbQV0cor63gWZvqkDG9SaqiBSJpMoAMBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDUwMzE2MTIxNFowXAYJKoZIhvcNAQkPMU8wTTAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBALS1KvVlW159Z5/NAxC2OA1q/22C
xydAZnb3mSwQUh/zK1R0LkA6CYBh9diDVvBOIsHCe9G4YptqBic+kII6F4ZT3XIvX77mCQLURR4h
6P3xeuTDGQ0O4eOaNi7yTy44rEyfkMaCyoxUxyjRxIEfZIiqmInIzqd2Dn8yb6Tue8iAxXgZZBnq
gqmb/wH2By5iIaHwog1VDwIIkawq2q1sQ1/lWyqqfZ1DEa0w3yNW2Tkkd04P+wZSxVYpXIQmLC5e
q7+NoZ+vjpE5MtIPPQpAJ7/iAl8VSt86YTL0RVrxw/Fsp34Mn1rQhRYPc7caypETmH59FSI4ZPLn
zcfydgw35Uw=
--000000000000b4eb2506343d87a2--
