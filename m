Return-Path: <SRS0=SmAa=EF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A19C55178
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 16:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0E9E2223F
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 16:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mjJus0dv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgJ3QH4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Oct 2020 12:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3QHz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Oct 2020 12:07:55 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4A3C0613CF
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2020 09:07:54 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id m3so1555743vki.12
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2020 09:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y5CoSCnNRhCRozrYeGNW0V+sIJdvVi8383p8d1OtLeQ=;
        b=mjJus0dvjSV9n4U6vqculXyM/k8ixxRixp07EK63G3QLr+wccVHK30Njor11feGdde
         L53UCuDYf1n9hsHgnWmS0qXhYXyUrehnMd81hVRPqOsR/IeQm7csHJjBP7kSZkq3rM87
         FKc9jaWWJ7NJliKNJVeUjocOZHsnXdN+y64azgVit+LdJNyGsCHp1tKOj0CZnRhYevP3
         yJmy6xccZF/BP2VvyMHGB8JckGVpPHOzXvEmmW+Oano35hzQXLToXohe6A3U7UT5JVpA
         7FmZ7WYW46SBkOjMUfufb/UF9+8kVcXoTDvespAMWj2YVd98dPktuBMTB5bJsGsPLwv7
         9lnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y5CoSCnNRhCRozrYeGNW0V+sIJdvVi8383p8d1OtLeQ=;
        b=TtOuHp9dMKDTa8GWLvV75/lI37LH9dB2883g4PR/uxQUfn7Jah/OjgPpcVvd3h7AHW
         7EXBjFRuimTqzOE8diTCAa5UP3d4eg5B9Wgm78GpkyMXQwyu0QkKP2cqxUN/f8aoF1m6
         i7AW22Wi4ATdeojCgYy0J+Uui40RYtB9N4fhPM+iVYAyV/D5YlPem2E2poaT8Ca41/by
         3xtP+LXhk8lHmM89E0Xoija68g8ok8mIEFu/P73ftfqJbp+b+h99Dgpn7h3KM19bGhir
         CgxfhIBPSlUF7VXR+diN8M5HqZqNqt6Mwa5RX/J8NoMfXuHzOptSNTmc6NxIsn7F29mK
         WDaw==
X-Gm-Message-State: AOAM530t3LK09sK2lWBh37qSUyHV6lFqvC99QC/kCZI3TDS58Z9nrAnu
        cxSBUTl/IV3Fer9EzamD6oHCIvEK4w0=
X-Google-Smtp-Source: ABdhPJx6Brtx2UYs9S+4SHVvw2AaZU4S2/pxLytr+jawpdFSPLK276jlaIfrfdlKlLTqO14zg9+4hw==
X-Received: by 2002:ac5:c84f:: with SMTP id g15mr7809181vkm.11.1604074072670;
        Fri, 30 Oct 2020 09:07:52 -0700 (PDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id w184sm577799vsw.3.2020.10.30.09.07.50
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 09:07:51 -0700 (PDT)
Received: by mail-ua1-f51.google.com with SMTP id y1so1857306uac.13
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2020 09:07:50 -0700 (PDT)
X-Received: by 2002:ab0:299a:: with SMTP id u26mr1952445uap.108.1604074070157;
 Fri, 30 Oct 2020 09:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201028145015.19212-1-schalla@marvell.com> <20201028145015.19212-3-schalla@marvell.com>
In-Reply-To: <20201028145015.19212-3-schalla@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 12:07:13 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeLG+WV_Et75trH1kF0ahFpqfe2SvMRfjKk+OYycWktVw@mail.gmail.com>
Message-ID: <CA+FuTSeLG+WV_Et75trH1kF0ahFpqfe2SvMRfjKk+OYycWktVw@mail.gmail.com>
Subject: Re: [PATCH v8,net-next,02/12] octeontx2-af: add mailbox interface for CPT
To:     Srujana Challa <schalla@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 28, 2020 at 10:44 PM Srujana Challa <schalla@marvell.com> wrote:
>
> On OcteonTX2 SoC, the admin function (AF) is the only one with all
> priviliges to configure HW and alloc resources, PFs and it's VFs
> have to request AF via mailbox for all their needs. This patch adds
> a mailbox interface for CPT PFs and VFs to allocate resources
> for cryptography.
>
> Signed-off-by: Suheil Chandran <schandran@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/af/Makefile    |   3 +-
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |  33 +++
>  .../net/ethernet/marvell/octeontx2/af/rvu.c   |   2 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |   1 +
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 229 ++++++++++++++++++
>  .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  63 ++++-
>  6 files changed, 323 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> index 7ca599b973c0..807b1c1a9d85 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> @@ -429,12 +429,63 @@
>  #define TIM_AF_LF_RST                  (0x20)
>
>  /* CPT */
> -#define CPT_AF_CONSTANTS0              (0x0000)
> -#define CPT_PRIV_LFX_CFG               (0x41000)
> -#define CPT_PRIV_LFX_INT_CFG           (0x43000)
> -#define CPT_AF_RVU_LF_CFG_DEBUG                (0x45000)
> -#define CPT_AF_LF_RST                  (0x44000)
> -#define CPT_AF_BLK_RST                 (0x46000)
> +#define CPT_AF_CONSTANTS0               (0x0000)
> +#define CPT_AF_CONSTANTS1               (0x1000)
> +#define CPT_AF_DIAG                     (0x3000)
> +#define CPT_AF_ECO                      (0x4000)
> +#define CPT_AF_FLTX_INT(a)              (0xa000ull | (u64)(a) << 3)
> +#define CPT_AF_FLTX_INT_W1S(a)          (0xb000ull | (u64)(a) << 3)
> +#define CPT_AF_FLTX_INT_ENA_W1C(a)      (0xc000ull | (u64)(a) << 3)
> +#define CPT_AF_FLTX_INT_ENA_W1S(a)      (0xd000ull | (u64)(a) << 3)
> +#define CPT_AF_PSNX_EXE(a)              (0xe000ull | (u64)(a) << 3)
> +#define CPT_AF_PSNX_EXE_W1S(a)          (0xf000ull | (u64)(a) << 3)
> +#define CPT_AF_PSNX_LF(a)               (0x10000ull | (u64)(a) << 3)
> +#define CPT_AF_PSNX_LF_W1S(a)           (0x11000ull | (u64)(a) << 3)
> +#define CPT_AF_EXEX_CTL2(a)             (0x12000ull | (u64)(a) << 3)
> +#define CPT_AF_EXEX_STS(a)              (0x13000ull | (u64)(a) << 3)
> +#define CPT_AF_EXE_ERR_INFO             (0x14000)
> +#define CPT_AF_EXEX_ACTIVE(a)           (0x16000ull | (u64)(a) << 3)
> +#define CPT_AF_INST_REQ_PC              (0x17000)
> +#define CPT_AF_INST_LATENCY_PC          (0x18000)
> +#define CPT_AF_RD_REQ_PC                (0x19000)
> +#define CPT_AF_RD_LATENCY_PC            (0x1a000)
> +#define CPT_AF_RD_UC_PC                 (0x1b000)
> +#define CPT_AF_ACTIVE_CYCLES_PC         (0x1c000)
> +#define CPT_AF_EXE_DBG_CTL              (0x1d000)
> +#define CPT_AF_EXE_DBG_DATA             (0x1e000)
> +#define CPT_AF_EXE_REQ_TIMER            (0x1f000)
> +#define CPT_AF_EXEX_CTL(a)              (0x20000ull | (u64)(a) << 3)
> +#define CPT_AF_EXE_PERF_CTL             (0x21000)
> +#define CPT_AF_EXE_DBG_CNTX(a)          (0x22000ull | (u64)(a) << 3)
> +#define CPT_AF_EXE_PERF_EVENT_CNT       (0x23000)
> +#define CPT_AF_EXE_EPCI_INBX_CNT(a)     (0x24000ull | (u64)(a) << 3)
> +#define CPT_AF_EXE_EPCI_OUTBX_CNT(a)    (0x25000ull | (u64)(a) << 3)
> +#define CPT_AF_EXEX_UCODE_BASE(a)       (0x26000ull | (u64)(a) << 3)
> +#define CPT_AF_LFX_CTL(a)               (0x27000ull | (u64)(a) << 3)
> +#define CPT_AF_LFX_CTL2(a)              (0x29000ull | (u64)(a) << 3)
> +#define CPT_AF_CPTCLK_CNT               (0x2a000)
> +#define CPT_AF_PF_FUNC                  (0x2b000)
> +#define CPT_AF_LFX_PTR_CTL(a)           (0x2c000ull | (u64)(a) << 3)
> +#define CPT_AF_GRPX_THR(a)              (0x2d000ull | (u64)(a) << 3)
> +#define CPT_AF_CTL                      (0x2e000ull)
> +#define CPT_AF_XEX_THR(a)               (0x2f000ull | (u64)(a) << 3)
> +#define CPT_PRIV_LFX_CFG                (0x41000)
> +#define CPT_PRIV_AF_INT_CFG             (0x42000)
> +#define CPT_PRIV_LFX_INT_CFG            (0x43000)
> +#define CPT_AF_LF_RST                   (0x44000)
> +#define CPT_AF_RVU_LF_CFG_DEBUG         (0x45000)
> +#define CPT_AF_BLK_RST                  (0x46000)
> +#define CPT_AF_RVU_INT                  (0x47000)
> +#define CPT_AF_RVU_INT_W1S              (0x47008)
> +#define CPT_AF_RVU_INT_ENA_W1S          (0x47010)
> +#define CPT_AF_RVU_INT_ENA_W1C          (0x47018)
> +#define CPT_AF_RAS_INT                  (0x47020)
> +#define CPT_AF_RAS_INT_W1S              (0x47028)
> +#define CPT_AF_RAS_INT_ENA_W1S          (0x47030)
> +#define CPT_AF_RAS_INT_ENA_W1C          (0x47038)
> +
> +#define CPT_AF_LF_CTL2_SHIFT 3
> +#define CPT_AF_LF_SSO_PF_FUNC_SHIFT 32
>
>  #define NPC_AF_BLK_RST                  (0x00040)

Most of these are not related to this patch. Used only in the
follow-on debug interface one?
