Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="e1aSkk/O"
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0A0FD
	for <linux-crypto@vger.kernel.org>; Mon, 11 Dec 2023 00:12:39 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-50c222a022dso4251923e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 11 Dec 2023 00:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1702282357; x=1702887157; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UPPrW/w5OHLqEgBKsxvx8+8lauP/f1TUEs1UpZp0c8M=;
        b=e1aSkk/Ov7fjNJd/7lC/QS1HX+rqPxtj09q8bN3iwKumsWr+rTKAGDxaYwVdgynIah
         NXDOfoyev09Itb9coavYLfR0VboMvbFmx0GMdLiOXcsswoSL0iGUNXw3ndMKIRlizjfL
         N0QoztjQiUTeaFh6twG+rvPybw586vt+tx2CY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702282357; x=1702887157;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UPPrW/w5OHLqEgBKsxvx8+8lauP/f1TUEs1UpZp0c8M=;
        b=aDDPKX5Weke+YyvOlKaCgTG+gTWz+JbzX/Dr5kIYYcV4MFzTj7tczUvi1dVQxABQ2j
         cPRW7L+qMoZhMFGiHgrbDnAycrX2g1ZgIVhLnzDHMuy+PGsbg0V54i9VYzZE9602/H5O
         KsgrVVM37B2cjf8yHE3KaJKpr3RQkRkvPQOJeKDxqbD4y/k89gsjJKQ9X9aNiZFIEfsR
         HbJ/Fo+dJYtKIv/gdiXjYnp9OyEToecvxxql7KB8YePTd6jabR8LJbUB+RxUFbvmkFqE
         0gvOsCbdQM+Led8vvsUu9giwBKZtNckgvHWheGbI5XT7tISon7iASYSCkzRe2wh7ee71
         JREg==
X-Gm-Message-State: AOJu0YzaMZ+H2vRX53LllpzHZKWkH7rua8loASbk8aF7LsMqekG9HMbQ
	IYE814OGOlu9v4v6bVEjWd9qqVtIU3DrKKHiyVCwW8YdBA2o3BxI
X-Google-Smtp-Source: AGHT+IGXr6crGd8sAF19HTxRwkKL37fjlLnY8KnhgH2nYz44+PM/h8aADuNZ1lKrtj82WjcJQYULCPvGq7OOpxQH52g=
X-Received: by 2002:a19:4341:0:b0:50b:e7b4:6d17 with SMTP id
 m1-20020a194341000000b0050be7b46d17mr1555620lfj.56.1702282357404; Mon, 11 Dec
 2023 00:12:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231211071913.151225-1-schalla@marvell.com> <20231211071913.151225-3-schalla@marvell.com>
In-Reply-To: <20231211071913.151225-3-schalla@marvell.com>
From: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Date: Mon, 11 Dec 2023 13:42:25 +0530
Message-ID: <CAH-L+nNEg-WVNdoN6aw3esnhAn60pnj7NN26=X_1F3BgCV07rA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 02/10] :crypto: octeontx2: add SGv2 support
 for CN10KB or CN10KA B0
To: Srujana Challa <schalla@marvell.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org, 
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org, bbrezillon@kernel.org, arno@natisbad.org, 
	pabeni@redhat.com, edumazet@google.com, corbet@lwn.net, sgoutham@marvell.com, 
	bbhushan2@marvell.com, jerinj@marvell.com, sbhatta@marvell.com, 
	hkelam@marvell.com, lcherian@marvell.com, gakula@marvell.com, 
	ndabilpuram@marvell.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000412dd1060c377f53"

--000000000000412dd1060c377f53
Content-Type: multipart/alternative; boundary="00000000000038e9b0060c377f60"

--00000000000038e9b0060c377f60
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Srujana,

Looks like you ignored my comments on V1 of your patch.

On Mon, Dec 11, 2023 at 12:50=E2=80=AFPM Srujana Challa <schalla@marvell.co=
m> wrote:

> Scatter Gather input format for CPT has changed on CN10KB/CN10KA B0 HW
> to make it comapatible with NIX Scatter Gather format to support SG mode
> for inline IPsec. This patch modifies the code to make the driver works
> for the same. This patch also enables CPT firmware load for these chips.
>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.c  |  19 +-
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |   1 +
>  .../marvell/octeontx2/otx2_cpt_common.h       |  41 ++-
>  .../marvell/octeontx2/otx2_cpt_hw_types.h     |   3 +
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 293 ++++++++++++++++++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h |   2 +
>  .../marvell/octeontx2/otx2_cptpf_main.c       |  26 +-
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       |   2 +-
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      |  33 +-
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |   3 +-
>  drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   2 +
>  .../marvell/octeontx2/otx2_cptvf_main.c       |  13 +
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  26 ++
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 160 +---------
>  14 files changed, 447 insertions(+), 177 deletions(-)
>
> diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
> b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
> index 93d22b328991..b23ae3a020e0 100644
> --- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
> +++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
> @@ -14,12 +14,14 @@ static struct cpt_hw_ops otx2_hw_ops =3D {
>         .send_cmd =3D otx2_cpt_send_cmd,
>         .cpt_get_compcode =3D otx2_cpt_get_compcode,
>         .cpt_get_uc_compcode =3D otx2_cpt_get_uc_compcode,
> +       .cpt_sg_info_create =3D otx2_sg_info_create,
>  };
>
>  static struct cpt_hw_ops cn10k_hw_ops =3D {
>         .send_cmd =3D cn10k_cpt_send_cmd,
>         .cpt_get_compcode =3D cn10k_cpt_get_compcode,
>         .cpt_get_uc_compcode =3D cn10k_cpt_get_uc_compcode,
> +       .cpt_sg_info_create =3D otx2_sg_info_create,
>  };
>
>  static void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32
> insts_num,
> @@ -78,12 +80,9 @@ int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptv=
f)
>         struct pci_dev *pdev =3D cptvf->pdev;
>         resource_size_t offset, size;
>
> -       if (!test_bit(CN10K_LMTST, &cptvf->cap_flag)) {
> -               cptvf->lfs.ops =3D &otx2_hw_ops;
> +       if (!test_bit(CN10K_LMTST, &cptvf->cap_flag))
>                 return 0;
> -       }
>
> -       cptvf->lfs.ops =3D &cn10k_hw_ops;
>         offset =3D pci_resource_start(pdev, PCI_MBOX_BAR_NUM);
>         size =3D pci_resource_len(pdev, PCI_MBOX_BAR_NUM);
>         /* Map VF LMILINE region */
> @@ -96,3 +95,15 @@ int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptv=
f)
>         return 0;
>  }
>  EXPORT_SYMBOL_NS_GPL(cn10k_cptvf_lmtst_init, CRYPTO_DEV_OCTEONTX2_CPT);
> +
> +int cptvf_hw_ops_get(struct otx2_cptvf_dev *cptvf)
> +{
> +       if (!test_bit(CN10K_LMTST, &cptvf->cap_flag)) {
> +               cptvf->lfs.ops =3D &otx2_hw_ops;
> +               return 0;
> +       }
> +       cptvf->lfs.ops =3D &cn10k_hw_ops;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cptvf_hw_ops_get, CRYPTO_DEV_OCTEONTX2_CPT);
>
[Kalesh]: You can make this function return void as it returns 0 always.
+void cptvf_hw_ops_get(struct otx2_cptvf_dev *cptvf)
+{
+       if (!test_bit(CN10K_LMTST, &cptvf->cap_flag))
+               cptvf->lfs.ops =3D &otx2_hw_ops;
+       else
+               cptvf->lfs.ops =3D &cn10k_hw_ops;
+}

> diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
> b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
> index aaefc7e38e06..0f714ee564f5 100644
> --- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
> +++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
> @@ -30,5 +30,6 @@ static inline u8 otx2_cpt_get_uc_compcode(union
> otx2_cpt_res_s *result)
>
>  int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf);
>  int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf);
> +int cptvf_hw_ops_get(struct otx2_cptvf_dev *cptvf);
>
>  #endif /* __CN10K_CPTLF_H */
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> index 46b778bbbee4..2a7544252444 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> @@ -102,7 +102,10 @@ union otx2_cpt_eng_caps {
>                 u64 kasumi:1;
>                 u64 des:1;
>                 u64 crc:1;
> -               u64 reserved_14_63:50;
> +               u64 mmul:1;
> +               u64 reserved_15_33:19;
> +               u64 pdcp_chain:1;
> +               u64 reserved_35_63:29;
>         };
>  };
>
> @@ -145,6 +148,41 @@ static inline bool is_dev_otx2(struct pci_dev *pdev)
>         return false;
>  }
>
> +static inline bool is_dev_cn10ka(struct pci_dev *pdev)
> +{
> +       if (pdev->subsystem_device =3D=3D CPT_PCI_SUBSYS_DEVID_CN10K_A)
> +               return true;
> +
> +       return false;
> +}
>
[Kalesh]: You can further simply this as:
return pdev->subsystem_device =3D=3D CPT_PCI_SUBSYS_DEVID_CN10K_A

> +
> +static inline bool is_dev_cn10ka_ax(struct pci_dev *pdev)
> +{
> +       if (pdev->subsystem_device =3D=3D CPT_PCI_SUBSYS_DEVID_CN10K_A &&
> +           ((pdev->revision & 0xFF) =3D=3D 4 || (pdev->revision & 0xFF) =
=3D=3D
> 0x50 ||
> +            (pdev->revision & 0xff) =3D=3D 0x51))
> +               return true;
> +
> +       return false;
> +}
> +
> +static inline bool is_dev_cn10kb(struct pci_dev *pdev)
> +{
> +       if (pdev->subsystem_device =3D=3D CPT_PCI_SUBSYS_DEVID_CN10K_B)
> +               return true;
> +
> +       return false;
> +}
>
[Kalesh]: You can further simply this as:
return pdev->subsystem_device =3D=3D CPT_PCI_SUBSYS_DEVID_CN10K_B

> +
> +static inline bool is_dev_cn10ka_b0(struct pci_dev *pdev)
> +{
> +       if (pdev->subsystem_device =3D=3D CPT_PCI_SUBSYS_DEVID_CN10K_A &&
> +           (pdev->revision & 0xFF) =3D=3D 0x54)
> +               return true;
> +
> +       return false;
> +}
> +
>  static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
>                                         unsigned long *cap_flag)
>  {
> @@ -154,7 +192,6 @@ static inline void otx2_cpt_set_hw_caps(struct pci_de=
v
> *pdev,
>         }
>  }
>
> -
>
[Kalesh]: This change looks unrelated

>  int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev=
);
>  int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pdev)=
;
>
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
> b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
> index 6f947978e4e8..756aee0c2b05 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
> @@ -13,6 +13,9 @@
>  #define CN10K_CPT_PCI_PF_DEVICE_ID 0xA0F2
>  #define CN10K_CPT_PCI_VF_DEVICE_ID 0xA0F3
>
> +#define CPT_PCI_SUBSYS_DEVID_CN10K_A 0xB900
> +#define CPT_PCI_SUBSYS_DEVID_CN10K_B 0xBD00
> +
>  /* Mailbox interrupts offset */
>  #define OTX2_CPT_PF_MBOX_INT   6
>  #define OTX2_CPT_PF_INT_VEC_E_MBOXX(x, a) ((x) + (a))
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
> b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
> index dbb1ee746f4c..b0f426531a42 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
> @@ -143,6 +143,8 @@ struct otx2_cpt_inst_info {
>         unsigned long time_in;
>         u32 dlen;
>         u32 dma_len;
> +       u64 gthr_sz;
> +       u64 sctr_sz;
>         u8 extra_time;
>  };
>
> @@ -157,6 +159,16 @@ struct otx2_cpt_sglist_component {
>         __be64 ptr3;
>  };
>
> +struct cn10kb_cpt_sglist_component {
> +       u16 len0;
> +       u16 len1;
> +       u16 len2;
> +       u16 valid_segs;
> +       u64 ptr0;
> +       u64 ptr1;
> +       u64 ptr2;
> +};
> +
>  static inline void otx2_cpt_info_destroy(struct pci_dev *pdev,
>                                          struct otx2_cpt_inst_info *info)
>  {
> @@ -188,6 +200,287 @@ static inline void otx2_cpt_info_destroy(struct
> pci_dev *pdev,
>         kfree(info);
>  }
>
> +static inline int setup_sgio_components(struct pci_dev *pdev,
> +                                       struct otx2_cpt_buf_ptr *list,
> +                                       int buf_count, u8 *buffer)
> +{
> +       struct otx2_cpt_sglist_component *sg_ptr =3D NULL;
> +       int ret =3D 0, i, j;
> +       int components;
> +
> +       if (unlikely(!list)) {
> +               dev_err(&pdev->dev, "Input list pointer is NULL\n");
> +               return -EFAULT;
> +       }
> +
> +       for (i =3D 0; i < buf_count; i++) {
> +               if (unlikely(!list[i].vptr))
> +                       continue;
> +               list[i].dma_addr =3D dma_map_single(&pdev->dev, list[i].v=
ptr,
> +                                                 list[i].size,
> +                                                 DMA_BIDIRECTIONAL);
> +               if (unlikely(dma_mapping_error(&pdev->dev,
> list[i].dma_addr))) {
> +                       dev_err(&pdev->dev, "Dma mapping failed\n");
> +                       ret =3D -EIO;
> +                       goto sg_cleanup;
> +               }
> +       }
> +       components =3D buf_count / 4;
> +       sg_ptr =3D (struct otx2_cpt_sglist_component *)buffer;
> +       for (i =3D 0; i < components; i++) {
> +               sg_ptr->len0 =3D cpu_to_be16(list[i * 4 + 0].size);
> +               sg_ptr->len1 =3D cpu_to_be16(list[i * 4 + 1].size);
> +               sg_ptr->len2 =3D cpu_to_be16(list[i * 4 + 2].size);
> +               sg_ptr->len3 =3D cpu_to_be16(list[i * 4 + 3].size);
> +               sg_ptr->ptr0 =3D cpu_to_be64(list[i * 4 + 0].dma_addr);
> +               sg_ptr->ptr1 =3D cpu_to_be64(list[i * 4 + 1].dma_addr);
> +               sg_ptr->ptr2 =3D cpu_to_be64(list[i * 4 + 2].dma_addr);
> +               sg_ptr->ptr3 =3D cpu_to_be64(list[i * 4 + 3].dma_addr);
> +               sg_ptr++;
> +       }
> +       components =3D buf_count % 4;
> +
> +       switch (components) {
> +       case 3:
> +               sg_ptr->len2 =3D cpu_to_be16(list[i * 4 + 2].size);
> +               sg_ptr->ptr2 =3D cpu_to_be64(list[i * 4 + 2].dma_addr);
> +               fallthrough;
> +       case 2:
> +               sg_ptr->len1 =3D cpu_to_be16(list[i * 4 + 1].size);
> +               sg_ptr->ptr1 =3D cpu_to_be64(list[i * 4 + 1].dma_addr);
> +               fallthrough;
> +       case 1:
> +               sg_ptr->len0 =3D cpu_to_be16(list[i * 4 + 0].size);
> +               sg_ptr->ptr0 =3D cpu_to_be64(list[i * 4 + 0].dma_addr);
> +               break;
> +       default:
> +               break;
> +       }
> +       return ret;
> +
> +sg_cleanup:
> +       for (j =3D 0; j < i; j++) {
> +               if (list[j].dma_addr) {
> +                       dma_unmap_single(&pdev->dev, list[j].dma_addr,
> +                                        list[j].size, DMA_BIDIRECTIONAL)=
;
> +               }
> +
> +               list[j].dma_addr =3D 0;
> +       }
> +       return ret;
> +}
> +
> +static inline int sgv2io_components_setup(struct pci_dev *pdev,
> +                                         struct otx2_cpt_buf_ptr *list,
> +                                         int buf_count, u8 *buffer)
> +{
> +       struct cn10kb_cpt_sglist_component *sg_ptr =3D NULL;
> +       int ret =3D 0, i, j;
> +       int components;
>
[Kalesh]: maintain RCT order

> +
> +       if (unlikely(!list)) {
> +               dev_err(&pdev->dev, "Input list pointer is NULL\n");
> +               return -EFAULT;
> +       }
> +
> +       for (i =3D 0; i < buf_count; i++) {
> +               if (unlikely(!list[i].vptr))
> +                       continue;
> +               list[i].dma_addr =3D dma_map_single(&pdev->dev, list[i].v=
ptr,
> +                                                 list[i].size,
> +                                                 DMA_BIDIRECTIONAL);
> +               if (unlikely(dma_mapping_error(&pdev->dev,
> list[i].dma_addr))) {
> +                       dev_err(&pdev->dev, "Dma mapping failed\n");
> +                       ret =3D -EIO;
> +                       goto sg_cleanup;
> +               }
> +       }
> +       components =3D buf_count / 3;
> +       sg_ptr =3D (struct cn10kb_cpt_sglist_component *)buffer;
> +       for (i =3D 0; i < components; i++) {
> +               sg_ptr->len0 =3D list[i * 3 + 0].size;
> +               sg_ptr->len1 =3D list[i * 3 + 1].size;
> +               sg_ptr->len2 =3D list[i * 3 + 2].size;
> +               sg_ptr->ptr0 =3D list[i * 3 + 0].dma_addr;
> +               sg_ptr->ptr1 =3D list[i * 3 + 1].dma_addr;
> +               sg_ptr->ptr2 =3D list[i * 3 + 2].dma_addr;
> +               sg_ptr->valid_segs =3D 3;
> +               sg_ptr++;
> +       }
> +       components =3D buf_count % 3;
> +
> +       sg_ptr->valid_segs =3D components;
> +       switch (components) {
> +       case 2:
> +               sg_ptr->len1 =3D list[i * 3 + 1].size;
> +               sg_ptr->ptr1 =3D list[i * 3 + 1].dma_addr;
> +               fallthrough;
> +       case 1:
> +               sg_ptr->len0 =3D list[i * 3 + 0].size;
> +               sg_ptr->ptr0 =3D list[i * 3 + 0].dma_addr;
> +               break;
> +       default:
> +               break;
> +       }
> +       return ret;
> +
> +sg_cleanup:
> +       for (j =3D 0; j < i; j++) {
> +               if (list[j].dma_addr) {
> +                       dma_unmap_single(&pdev->dev, list[j].dma_addr,
> +                                        list[j].size, DMA_BIDIRECTIONAL)=
;
> +               }
> +
> +               list[j].dma_addr =3D 0;
> +       }
> +       return ret;
> +}
> +
> +static inline struct otx2_cpt_inst_info *cn10k_sgv2_info_create(
> +                                             struct pci_dev *pdev,
> +                                             struct otx2_cpt_req_info
> *req,
> +                                             gfp_t gfp)
> +{
> +       u32 dlen =3D 0, g_len, sg_len, info_len;
> +       int align =3D OTX2_CPT_DMA_MINALIGN;
> +       struct otx2_cpt_inst_info *info;
> +       u16 g_sz_bytes, s_sz_bytes;
> +       u32 total_mem_len;
> +       int i;
> +
> +       g_sz_bytes =3D ((req->in_cnt + 2) / 3) *
> +                     sizeof(struct cn10kb_cpt_sglist_component);
> +       s_sz_bytes =3D ((req->out_cnt + 2) / 3) *
> +                     sizeof(struct cn10kb_cpt_sglist_component);
> +
> +       g_len =3D ALIGN(g_sz_bytes, align);
> +       sg_len =3D ALIGN(g_len + s_sz_bytes, align);
> +       info_len =3D ALIGN(sizeof(*info), align);
> +       total_mem_len =3D sg_len + info_len + sizeof(union otx2_cpt_res_s=
);
> +
> +       info =3D kzalloc(total_mem_len, gfp);
> +       if (unlikely(!info))
> +               return NULL;
> +
> +       for (i =3D 0; i < req->in_cnt; i++)
> +               dlen +=3D req->in[i].size;
> +
> +       info->dlen =3D dlen;
> +       info->in_buffer =3D (u8 *)info + info_len;
> +       info->gthr_sz =3D req->in_cnt;
> +       info->sctr_sz =3D req->out_cnt;
> +
> +       /* Setup gather (input) components */
> +       if (sgv2io_components_setup(pdev, req->in, req->in_cnt,
> +                                   info->in_buffer)) {
> +               dev_err(&pdev->dev, "Failed to setup gather list\n");
> +               goto destroy_info;
> +       }
> +
> +       if (sgv2io_components_setup(pdev, req->out, req->out_cnt,
> +                                   &info->in_buffer[g_len])) {
> +               dev_err(&pdev->dev, "Failed to setup scatter list\n");
> +               goto destroy_info;
> +       }
> +
> +       info->dma_len =3D total_mem_len - info_len;
> +       info->dptr_baddr =3D dma_map_single(&pdev->dev, info->in_buffer,
> +                                         info->dma_len,
> DMA_BIDIRECTIONAL);
> +       if (unlikely(dma_mapping_error(&pdev->dev, info->dptr_baddr))) {
> +               dev_err(&pdev->dev, "DMA Mapping failed for cpt req\n");
> +               goto destroy_info;
> +       }
> +       info->rptr_baddr =3D info->dptr_baddr + g_len;
> +       /*
> +        * Get buffer for union otx2_cpt_res_s response
> +        * structure and its physical address
> +        */
> +       info->completion_addr =3D info->in_buffer + sg_len;
> +       info->comp_baddr =3D info->dptr_baddr + sg_len;
> +
> +       return info;
> +
> +destroy_info:
> +       otx2_cpt_info_destroy(pdev, info);
> +       return NULL;
> +}
> +
> +/* SG list header size in bytes */
> +#define SG_LIST_HDR_SIZE       8
> +static inline struct otx2_cpt_inst_info *otx2_sg_info_create(
> +                                             struct pci_dev *pdev,
> +                                             struct otx2_cpt_req_info
> *req,
> +                                             gfp_t gfp)
> +{
> +       int align =3D OTX2_CPT_DMA_MINALIGN;
> +       struct otx2_cpt_inst_info *info;
> +       u32 dlen, align_dlen, info_len;
> +       u16 g_sz_bytes, s_sz_bytes;
> +       u32 total_mem_len;
> +
> +       if (unlikely(req->in_cnt > OTX2_CPT_MAX_SG_IN_CNT ||
> +                    req->out_cnt > OTX2_CPT_MAX_SG_OUT_CNT)) {
> +               dev_err(&pdev->dev, "Error too many sg components\n");
> +               return NULL;
> +       }
> +
> +       g_sz_bytes =3D ((req->in_cnt + 3) / 4) *
> +                     sizeof(struct otx2_cpt_sglist_component);
> +       s_sz_bytes =3D ((req->out_cnt + 3) / 4) *
> +                     sizeof(struct otx2_cpt_sglist_component);
> +
> +       dlen =3D g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
> +       align_dlen =3D ALIGN(dlen, align);
> +       info_len =3D ALIGN(sizeof(*info), align);
> +       total_mem_len =3D align_dlen + info_len + sizeof(union
> otx2_cpt_res_s);
> +
> +       info =3D kzalloc(total_mem_len, gfp);
> +       if (unlikely(!info))
> +               return NULL;
> +
> +       info->dlen =3D dlen;
> +       info->in_buffer =3D (u8 *)info + info_len;
> +
> +       ((u16 *)info->in_buffer)[0] =3D req->out_cnt;
> +       ((u16 *)info->in_buffer)[1] =3D req->in_cnt;
> +       ((u16 *)info->in_buffer)[2] =3D 0;
> +       ((u16 *)info->in_buffer)[3] =3D 0;
> +       cpu_to_be64s((u64 *)info->in_buffer);
> +
> +       /* Setup gather (input) components */
> +       if (setup_sgio_components(pdev, req->in, req->in_cnt,
> +                                 &info->in_buffer[8])) {
> +               dev_err(&pdev->dev, "Failed to setup gather list\n");
> +               goto destroy_info;
> +       }
> +
> +       if (setup_sgio_components(pdev, req->out, req->out_cnt,
> +                                 &info->in_buffer[8 + g_sz_bytes])) {
> +               dev_err(&pdev->dev, "Failed to setup scatter list\n");
> +               goto destroy_info;
> +       }
> +
> +       info->dma_len =3D total_mem_len - info_len;
> +       info->dptr_baddr =3D dma_map_single(&pdev->dev, info->in_buffer,
> +                                         info->dma_len,
> DMA_BIDIRECTIONAL);
> +       if (unlikely(dma_mapping_error(&pdev->dev, info->dptr_baddr))) {
> +               dev_err(&pdev->dev, "DMA Mapping failed for cpt req\n");
> +               goto destroy_info;
> +       }
> +       /*
> +        * Get buffer for union otx2_cpt_res_s response
> +        * structure and its physical address
> +        */
> +       info->completion_addr =3D info->in_buffer + align_dlen;
> +       info->comp_baddr =3D info->dptr_baddr + align_dlen;
> +
> +       return info;
> +
> +destroy_info:
> +       otx2_cpt_info_destroy(pdev, info);
>
[Kalesh]" Where is the memory allocated for "info" getting freed. The
memory is allocated locally inside this function.

> +       return NULL;
> +}
> +
>  struct otx2_cptlf_wqe;
>  int otx2_cpt_do_request(struct pci_dev *pdev, struct otx2_cpt_req_info
> *req,
>                         int cpu_num);
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
> b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
> index 5302fe3d0e6f..70138d65ba9e 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
> @@ -99,6 +99,8 @@ struct cpt_hw_ops {
>                          struct otx2_cptlf_info *lf);
>         u8 (*cpt_get_compcode)(union otx2_cpt_res_s *result);
>         u8 (*cpt_get_uc_compcode)(union otx2_cpt_res_s *result);
> +       struct otx2_cpt_inst_info * (*cpt_sg_info_create)(struct pci_dev
> *pdev,
> +                                    struct otx2_cpt_req_info *req, gfp_t
> gfp);
>  };
>
>  struct otx2_cptlfs_info {
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
> b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
> index 5436b0d3685c..c64c50a964ed 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
> @@ -14,6 +14,8 @@
>  #define OTX2_CPT_DRV_STRING  "Marvell RVU CPT Physical Function Driver"
>
>  #define CPT_UC_RID_CN9K_B0   1
> +#define CPT_UC_RID_CN10K_A   4
> +#define CPT_UC_RID_CN10K_B   5
>
>  static void cptpf_enable_vfpf_mbox_intr(struct otx2_cptpf_dev *cptpf,
>                                         int num_vfs)
> @@ -587,6 +589,26 @@ static int cpt_is_pf_usable(struct otx2_cptpf_dev
> *cptpf)
>         return 0;
>  }
>
> +static int cptpf_get_rid(struct pci_dev *pdev, struct otx2_cptpf_dev
> *cptpf)
> +{
> +       struct otx2_cpt_eng_grps *eng_grps =3D &cptpf->eng_grps;
> +       u64 reg_val =3D 0x0;
> +
> +       if (is_dev_otx2(pdev)) {
> +               eng_grps->rid =3D pdev->revision;
> +               return 0;
> +       }
> +       otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL, &reg_va=
l,
> +                            BLKADDR_CPT0);
> +       if ((is_dev_cn10ka_b0(pdev) && (reg_val & BIT_ULL(18))) ||
> +           is_dev_cn10ka_ax(pdev))
> +               eng_grps->rid =3D CPT_UC_RID_CN10K_A;
> +       else if (is_dev_cn10kb(pdev) || is_dev_cn10ka_b0(pdev))
> +               eng_grps->rid =3D CPT_UC_RID_CN10K_B;
> +
> +       return 0;
> +}
>
[Kalesh]: You can convert this function to return void as it always returns
0 always.

> +
>  static void cptpf_check_block_implemented(struct otx2_cptpf_dev *cptpf)
>  {
>         u64 cfg;
> @@ -657,7 +679,9 @@ static int cptpf_sriov_enable(struct pci_dev *pdev,
> int num_vfs)
>         ret =3D cptpf_register_vfpf_intr(cptpf, num_vfs);
>         if (ret)
>                 goto destroy_flr;
> -
> +       ret =3D cptpf_get_rid(pdev, cptpf);
> +       if (ret)
> +               goto disable_intr;
>         /* Get CPT HW capabilities using LOAD_FVC operation. */
>         ret =3D otx2_cpt_discover_eng_capabilities(cptpf);
>         if (ret)
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> index 480b3720f15a..390ed146d309 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> @@ -78,7 +78,7 @@ static int handle_msg_get_caps(struct otx2_cptpf_dev
> *cptpf,
>         rsp->hdr.sig =3D OTX2_MBOX_RSP_SIG;
>         rsp->hdr.pcifunc =3D req->pcifunc;
>         rsp->cpt_pf_drv_version =3D OTX2_CPT_PF_DRV_VERSION;
> -       rsp->cpt_revision =3D cptpf->pdev->revision;
> +       rsp->cpt_revision =3D cptpf->eng_grps.rid;
>         memcpy(&rsp->eng_caps, &cptpf->eng_caps, sizeof(rsp->eng_caps));
>
>         return 0;
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> index 1958b797a421..7fccc348f66e 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> @@ -117,12 +117,10 @@ static char *get_ucode_type_str(int ucode_type)
>
>  static int get_ucode_type(struct device *dev,
>                           struct otx2_cpt_ucode_hdr *ucode_hdr,
> -                         int *ucode_type)
> +                         int *ucode_type, u16 rid)
>  {
> -       struct otx2_cptpf_dev *cptpf =3D dev_get_drvdata(dev);
>         char ver_str_prefix[OTX2_CPT_UCODE_VER_STR_SZ];
>         char tmp_ver_str[OTX2_CPT_UCODE_VER_STR_SZ];
> -       struct pci_dev *pdev =3D cptpf->pdev;
>         int i, val =3D 0;
>         u8 nn;
>
> @@ -130,7 +128,7 @@ static int get_ucode_type(struct device *dev,
>         for (i =3D 0; i < strlen(tmp_ver_str); i++)
>                 tmp_ver_str[i] =3D tolower(tmp_ver_str[i]);
>
> -       sprintf(ver_str_prefix, "ocpt-%02d", pdev->revision);
> +       sprintf(ver_str_prefix, "ocpt-%02d", rid);
>         if (!strnstr(tmp_ver_str, ver_str_prefix,
> OTX2_CPT_UCODE_VER_STR_SZ))
>                 return -EINVAL;
>
> @@ -359,7 +357,7 @@ static int cpt_attach_and_enable_cores(struct
> otx2_cpt_eng_grp_info *eng_grp,
>  }
>
>  static int load_fw(struct device *dev, struct fw_info_t *fw_info,
> -                  char *filename)
> +                  char *filename, u16 rid)
>  {
>         struct otx2_cpt_ucode_hdr *ucode_hdr;
>         struct otx2_cpt_uc_info_t *uc_info;
> @@ -375,7 +373,7 @@ static int load_fw(struct device *dev, struct
> fw_info_t *fw_info,
>                 goto free_uc_info;
>
>         ucode_hdr =3D (struct otx2_cpt_ucode_hdr *)uc_info->fw->data;
> -       ret =3D get_ucode_type(dev, ucode_hdr, &ucode_type);
> +       ret =3D get_ucode_type(dev, ucode_hdr, &ucode_type, rid);
>         if (ret)
>                 goto release_fw;
>
> @@ -389,6 +387,7 @@ static int load_fw(struct device *dev, struct
> fw_info_t *fw_info,
>         set_ucode_filename(&uc_info->ucode, filename);
>         memcpy(uc_info->ucode.ver_str, ucode_hdr->ver_str,
>                OTX2_CPT_UCODE_VER_STR_SZ);
> +       uc_info->ucode.ver_str[OTX2_CPT_UCODE_VER_STR_SZ] =3D 0;
>         uc_info->ucode.ver_num =3D ucode_hdr->ver_num;
>         uc_info->ucode.type =3D ucode_type;
>         uc_info->ucode.size =3D ucode_size;
> @@ -448,7 +447,8 @@ static void print_uc_info(struct fw_info_t *fw_info)
>         }
>  }
>
> -static int cpt_ucode_load_fw(struct pci_dev *pdev, struct fw_info_t
> *fw_info)
> +static int cpt_ucode_load_fw(struct pci_dev *pdev, struct fw_info_t
> *fw_info,
> +                            u16 rid)
>  {
>         char filename[OTX2_CPT_NAME_LENGTH];
>         char eng_type[8] =3D {0};
> @@ -462,9 +462,9 @@ static int cpt_ucode_load_fw(struct pci_dev *pdev,
> struct fw_info_t *fw_info)
>                         eng_type[i] =3D tolower(eng_type[i]);
>
>                 snprintf(filename, sizeof(filename), "mrvl/cpt%02d/%s.out=
",
> -                        pdev->revision, eng_type);
> +                        rid, eng_type);
>                 /* Request firmware for each engine type */
> -               ret =3D load_fw(&pdev->dev, fw_info, filename);
> +               ret =3D load_fw(&pdev->dev, fw_info, filename, rid);
>                 if (ret)
>                         goto release_fw;
>         }
> @@ -1155,7 +1155,7 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev
> *cptpf,
>         if (eng_grps->is_grps_created)
>                 goto unlock;
>
> -       ret =3D cpt_ucode_load_fw(pdev, &fw_info);
> +       ret =3D cpt_ucode_load_fw(pdev, &fw_info, eng_grps->rid);
>         if (ret)
>                 goto unlock;
>
> @@ -1230,14 +1230,16 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_de=
v
> *cptpf,
>          */
>         rnm_to_cpt_errata_fixup(&pdev->dev);
>
> +       otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL, &reg_va=
l,
> +                            BLKADDR_CPT0);
>         /*
>          * Configure engine group mask to allow context prefetching
>          * for the groups and enable random number request, to enable
>          * CPT to request random numbers from RNM.
>          */
> +       reg_val |=3D OTX2_CPT_ALL_ENG_GRPS_MASK << 3 | BIT_ULL(16);
>         otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_CTL,
> -                             OTX2_CPT_ALL_ENG_GRPS_MASK << 3 |
> BIT_ULL(16),
> -                             BLKADDR_CPT0);
> +                             reg_val, BLKADDR_CPT0);
>         /*
>          * Set interval to periodically flush dirty data for the next
>          * CTX cache entry. Set the interval count to maximum supported
> @@ -1412,7 +1414,7 @@ static int create_eng_caps_discovery_grps(struct
> pci_dev *pdev,
>         int ret;
>
>         mutex_lock(&eng_grps->lock);
> -       ret =3D cpt_ucode_load_fw(pdev, &fw_info);
> +       ret =3D cpt_ucode_load_fw(pdev, &fw_info, eng_grps->rid);
>         if (ret) {
>                 mutex_unlock(&eng_grps->lock);
>                 return ret;
> @@ -1686,13 +1688,14 @@ int otx2_cpt_dl_custom_egrp_create(struct
> otx2_cptpf_dev *cptpf,
>                 goto err_unlock;
>         }
>         INIT_LIST_HEAD(&fw_info.ucodes);
> -       ret =3D load_fw(dev, &fw_info, ucode_filename[0]);
> +
> +       ret =3D load_fw(dev, &fw_info, ucode_filename[0], eng_grps->rid);
>         if (ret) {
>                 dev_err(dev, "Unable to load firmware %s\n",
> ucode_filename[0]);
>                 goto err_unlock;
>         }
>         if (ucode_idx > 1) {
> -               ret =3D load_fw(dev, &fw_info, ucode_filename[1]);
> +               ret =3D load_fw(dev, &fw_info, ucode_filename[1],
> eng_grps->rid);
>                 if (ret) {
>                         dev_err(dev, "Unable to load firmware %s\n",
>                                 ucode_filename[1]);
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
> b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
> index e69320a54b5d..365fe8943bd9 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
> @@ -73,7 +73,7 @@ struct otx2_cpt_ucode_hdr {
>  };
>
>  struct otx2_cpt_ucode {
> -       u8 ver_str[OTX2_CPT_UCODE_VER_STR_SZ];/*
> +       u8 ver_str[OTX2_CPT_UCODE_VER_STR_SZ + 1];/*
>                                                * ucode version in readabl=
e
>                                                * format
>                                                */
> @@ -150,6 +150,7 @@ struct otx2_cpt_eng_grps {
>         int engs_num;                   /* total number of engines
> supported */
>         u8 eng_ref_cnt[OTX2_CPT_MAX_ENGINES];/* engines reference count *=
/
>         bool is_grps_created; /* Is the engine groups are already created
> */
> +       u16 rid;
>  };
>  struct otx2_cptpf_dev;
>  int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
> b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
> index 994291e90da1..11ab9af1df15 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h
> @@ -22,6 +22,7 @@ struct otx2_cptvf_dev {
>         int blkaddr;
>         void *bbuf_base;
>         unsigned long cap_flag;
> +       u64 eng_caps[OTX2_CPT_MAX_ENG_TYPES];
>  };
>
>  irqreturn_t otx2_cptvf_pfvf_mbox_intr(int irq, void *arg);
> @@ -29,5 +30,6 @@ void otx2_cptvf_pfvf_mbox_handler(struct work_struct
> *work);
>  int otx2_cptvf_send_eng_grp_num_msg(struct otx2_cptvf_dev *cptvf, int
> eng_type);
>  int otx2_cptvf_send_kvf_limits_msg(struct otx2_cptvf_dev *cptvf);
>  int otx2_cpt_mbox_bbuf_init(struct otx2_cptvf_dev *cptvf, struct pci_dev
> *pdev);
> +int otx2_cptvf_send_caps_msg(struct otx2_cptvf_dev *cptvf);
>
>  #endif /* __OTX2_CPTVF_H */
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
> b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
> index bac729c885f9..5d1e11135c17 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
> @@ -380,6 +380,19 @@ static int otx2_cptvf_probe(struct pci_dev *pdev,
>                 goto destroy_pfvf_mbox;
>
>         cptvf->blkaddr =3D BLKADDR_CPT0;
> +
> +       ret =3D cptvf_hw_ops_get(cptvf);
> +       if (ret)
> +               goto unregister_interrupts;
>
[Kalesh]: No need to check return value here. See my other comment above.

> +
> +       ret =3D otx2_cptvf_send_caps_msg(cptvf);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Couldn't get CPT engine
> capabilities.\n");
> +               goto unregister_interrupts;
> +       }
> +       if (cptvf->eng_caps[OTX2_CPT_SE_TYPES] & BIT_ULL(35))
> +               cptvf->lfs.ops->cpt_sg_info_create =3D
> cn10k_sgv2_info_create;
> +
>         /* Initialize CPT LFs */
>         ret =3D cptvf_lf_init(cptvf);
>         if (ret)
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
> b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
> index 75c403f2b1d9..f68da1d08fdf 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
> @@ -72,6 +72,7 @@ static void process_pfvf_mbox_mbox_msg(struct
> otx2_cptvf_dev *cptvf,
>         struct otx2_cptlfs_info *lfs =3D &cptvf->lfs;
>         struct otx2_cpt_kvf_limits_rsp *rsp_limits;
>         struct otx2_cpt_egrp_num_rsp *rsp_grp;
> +       struct otx2_cpt_caps_rsp *eng_caps;
>         struct cpt_rd_wr_reg_msg *rsp_reg;
>         struct msix_offset_rsp *rsp_msix;
>         int i;
> @@ -127,6 +128,11 @@ static void process_pfvf_mbox_mbox_msg(struct
> otx2_cptvf_dev *cptvf,
>                 rsp_limits =3D (struct otx2_cpt_kvf_limits_rsp *) msg;
>                 cptvf->lfs.kvf_limits =3D rsp_limits->kvf_limits;
>                 break;
> +       case MBOX_MSG_GET_CAPS:
> +               eng_caps =3D (struct otx2_cpt_caps_rsp *)msg;
> +               memcpy(cptvf->eng_caps, eng_caps->eng_caps,
> +                      sizeof(cptvf->eng_caps));
> +               break;
>         default:
>                 dev_err(&cptvf->pdev->dev, "Unsupported msg %d
> received.\n",
>                         msg->id);
> @@ -205,3 +211,23 @@ int otx2_cptvf_send_kvf_limits_msg(struct
> otx2_cptvf_dev *cptvf)
>
>         return otx2_cpt_send_mbox_msg(mbox, pdev);
>  }
> +
> +int otx2_cptvf_send_caps_msg(struct otx2_cptvf_dev *cptvf)
> +{
> +       struct otx2_mbox *mbox =3D &cptvf->pfvf_mbox;
> +       struct pci_dev *pdev =3D cptvf->pdev;
> +       struct mbox_msghdr *req;
> +
> +       req =3D (struct mbox_msghdr *)
> +             otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
> +                                     sizeof(struct otx2_cpt_caps_rsp));
> +       if (!req) {
> +               dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
> +               return -EFAULT;
> +       }
> +       req->id =3D MBOX_MSG_GET_CAPS;
> +       req->sig =3D OTX2_MBOX_REQ_SIG;
> +       req->pcifunc =3D OTX2_CPT_RVU_PFFUNC(cptvf->vf_id, 0);
> +
> +       return otx2_cpt_send_mbox_msg(mbox, pdev);
> +}
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
> b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
> index 811ded72ce5f..997a2eb60c66 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
> @@ -4,9 +4,6 @@
>  #include "otx2_cptvf.h"
>  #include "otx2_cpt_common.h"
>
> -/* SG list header size in bytes */
> -#define SG_LIST_HDR_SIZE       8
> -
>  /* Default timeout when waiting for free pending entry in us */
>  #define CPT_PENTRY_TIMEOUT     1000
>  #define CPT_PENTRY_STEP                50
> @@ -26,9 +23,9 @@ static void otx2_cpt_dump_sg_list(struct pci_dev *pdev,
>
>         pr_debug("Gather list size %d\n", req->in_cnt);
>         for (i =3D 0; i < req->in_cnt; i++) {
> -               pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%p\n", i=
,
> +               pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%llx\n",
> i,
>                          req->in[i].size, req->in[i].vptr,
> -                        (void *) req->in[i].dma_addr);
> +                        req->in[i].dma_addr);
>                 pr_debug("Buffer hexdump (%d bytes)\n",
>                          req->in[i].size);
>                 print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1,
> @@ -36,9 +33,9 @@ static void otx2_cpt_dump_sg_list(struct pci_dev *pdev,
>         }
>         pr_debug("Scatter list size %d\n", req->out_cnt);
>         for (i =3D 0; i < req->out_cnt; i++) {
> -               pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%p\n", i=
,
> +               pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%llx\n",
> i,
>                          req->out[i].size, req->out[i].vptr,
> -                        (void *) req->out[i].dma_addr);
> +                        req->out[i].dma_addr);
>                 pr_debug("Buffer hexdump (%d bytes)\n", req->out[i].size)=
;
>                 print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1,
>                                      req->out[i].vptr, req->out[i].size,
> false);
> @@ -84,149 +81,6 @@ static inline void free_pentry(struct
> otx2_cpt_pending_entry *pentry)
>         pentry->busy =3D false;
>  }
>
> -static inline int setup_sgio_components(struct pci_dev *pdev,
> -                                       struct otx2_cpt_buf_ptr *list,
> -                                       int buf_count, u8 *buffer)
> -{
> -       struct otx2_cpt_sglist_component *sg_ptr =3D NULL;
> -       int ret =3D 0, i, j;
> -       int components;
> -
> -       if (unlikely(!list)) {
> -               dev_err(&pdev->dev, "Input list pointer is NULL\n");
> -               return -EFAULT;
> -       }
> -
> -       for (i =3D 0; i < buf_count; i++) {
> -               if (unlikely(!list[i].vptr))
> -                       continue;
> -               list[i].dma_addr =3D dma_map_single(&pdev->dev, list[i].v=
ptr,
> -                                                 list[i].size,
> -                                                 DMA_BIDIRECTIONAL);
> -               if (unlikely(dma_mapping_error(&pdev->dev,
> list[i].dma_addr))) {
> -                       dev_err(&pdev->dev, "Dma mapping failed\n");
> -                       ret =3D -EIO;
> -                       goto sg_cleanup;
> -               }
> -       }
> -       components =3D buf_count / 4;
> -       sg_ptr =3D (struct otx2_cpt_sglist_component *)buffer;
> -       for (i =3D 0; i < components; i++) {
> -               sg_ptr->len0 =3D cpu_to_be16(list[i * 4 + 0].size);
> -               sg_ptr->len1 =3D cpu_to_be16(list[i * 4 + 1].size);
> -               sg_ptr->len2 =3D cpu_to_be16(list[i * 4 + 2].size);
> -               sg_ptr->len3 =3D cpu_to_be16(list[i * 4 + 3].size);
> -               sg_ptr->ptr0 =3D cpu_to_be64(list[i * 4 + 0].dma_addr);
> -               sg_ptr->ptr1 =3D cpu_to_be64(list[i * 4 + 1].dma_addr);
> -               sg_ptr->ptr2 =3D cpu_to_be64(list[i * 4 + 2].dma_addr);
> -               sg_ptr->ptr3 =3D cpu_to_be64(list[i * 4 + 3].dma_addr);
> -               sg_ptr++;
> -       }
> -       components =3D buf_count % 4;
> -
> -       switch (components) {
> -       case 3:
> -               sg_ptr->len2 =3D cpu_to_be16(list[i * 4 + 2].size);
> -               sg_ptr->ptr2 =3D cpu_to_be64(list[i * 4 + 2].dma_addr);
> -               fallthrough;
> -       case 2:
> -               sg_ptr->len1 =3D cpu_to_be16(list[i * 4 + 1].size);
> -               sg_ptr->ptr1 =3D cpu_to_be64(list[i * 4 + 1].dma_addr);
> -               fallthrough;
> -       case 1:
> -               sg_ptr->len0 =3D cpu_to_be16(list[i * 4 + 0].size);
> -               sg_ptr->ptr0 =3D cpu_to_be64(list[i * 4 + 0].dma_addr);
> -               break;
> -       default:
> -               break;
> -       }
> -       return ret;
> -
> -sg_cleanup:
> -       for (j =3D 0; j < i; j++) {
> -               if (list[j].dma_addr) {
> -                       dma_unmap_single(&pdev->dev, list[j].dma_addr,
> -                                        list[j].size, DMA_BIDIRECTIONAL)=
;
> -               }
> -
> -               list[j].dma_addr =3D 0;
> -       }
> -       return ret;
> -}
> -
> -static inline struct otx2_cpt_inst_info *info_create(struct pci_dev *pde=
v,
> -                                             struct otx2_cpt_req_info
> *req,
> -                                             gfp_t gfp)
> -{
> -       int align =3D OTX2_CPT_DMA_MINALIGN;
> -       struct otx2_cpt_inst_info *info;
> -       u32 dlen, align_dlen, info_len;
> -       u16 g_sz_bytes, s_sz_bytes;
> -       u32 total_mem_len;
> -
> -       if (unlikely(req->in_cnt > OTX2_CPT_MAX_SG_IN_CNT ||
> -                    req->out_cnt > OTX2_CPT_MAX_SG_OUT_CNT)) {
> -               dev_err(&pdev->dev, "Error too many sg components\n");
> -               return NULL;
> -       }
> -
> -       g_sz_bytes =3D ((req->in_cnt + 3) / 4) *
> -                     sizeof(struct otx2_cpt_sglist_component);
> -       s_sz_bytes =3D ((req->out_cnt + 3) / 4) *
> -                     sizeof(struct otx2_cpt_sglist_component);
> -
> -       dlen =3D g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
> -       align_dlen =3D ALIGN(dlen, align);
> -       info_len =3D ALIGN(sizeof(*info), align);
> -       total_mem_len =3D align_dlen + info_len + sizeof(union
> otx2_cpt_res_s);
> -
> -       info =3D kzalloc(total_mem_len, gfp);
> -       if (unlikely(!info))
> -               return NULL;
> -
> -       info->dlen =3D dlen;
> -       info->in_buffer =3D (u8 *)info + info_len;
> -
> -       ((u16 *)info->in_buffer)[0] =3D req->out_cnt;
> -       ((u16 *)info->in_buffer)[1] =3D req->in_cnt;
> -       ((u16 *)info->in_buffer)[2] =3D 0;
> -       ((u16 *)info->in_buffer)[3] =3D 0;
> -       cpu_to_be64s((u64 *)info->in_buffer);
> -
> -       /* Setup gather (input) components */
> -       if (setup_sgio_components(pdev, req->in, req->in_cnt,
> -                                 &info->in_buffer[8])) {
> -               dev_err(&pdev->dev, "Failed to setup gather list\n");
> -               goto destroy_info;
> -       }
> -
> -       if (setup_sgio_components(pdev, req->out, req->out_cnt,
> -                                 &info->in_buffer[8 + g_sz_bytes])) {
> -               dev_err(&pdev->dev, "Failed to setup scatter list\n");
> -               goto destroy_info;
> -       }
> -
> -       info->dma_len =3D total_mem_len - info_len;
> -       info->dptr_baddr =3D dma_map_single(&pdev->dev, info->in_buffer,
> -                                         info->dma_len,
> DMA_BIDIRECTIONAL);
> -       if (unlikely(dma_mapping_error(&pdev->dev, info->dptr_baddr))) {
> -               dev_err(&pdev->dev, "DMA Mapping failed for cpt req\n");
> -               goto destroy_info;
> -       }
> -       /*
> -        * Get buffer for union otx2_cpt_res_s response
> -        * structure and its physical address
> -        */
> -       info->completion_addr =3D info->in_buffer + align_dlen;
> -       info->comp_baddr =3D info->dptr_baddr + align_dlen;
> -
> -       return info;
> -
> -destroy_info:
> -       otx2_cpt_info_destroy(pdev, info);
> -       return NULL;
> -}
> -
>  static int process_request(struct pci_dev *pdev, struct otx2_cpt_req_inf=
o
> *req,
>                            struct otx2_cpt_pending_queue *pqueue,
>                            struct otx2_cptlf_info *lf)
> @@ -247,7 +101,7 @@ static int process_request(struct pci_dev *pdev,
> struct otx2_cpt_req_info *req,
>         if (unlikely(!otx2_cptlf_started(lf->lfs)))
>                 return -ENODEV;
>
> -       info =3D info_create(pdev, req, gfp);
> +       info =3D lf->lfs->ops->cpt_sg_info_create(pdev, req, gfp);
>         if (unlikely(!info)) {
>                 dev_err(&pdev->dev, "Setting up cpt inst info failed");
>                 return -ENOMEM;
> @@ -303,8 +157,8 @@ static int process_request(struct pci_dev *pdev,
> struct otx2_cpt_req_info *req,
>
>         /* 64-bit swap for microcode data reads, not needed for addresses=
*/
>         cpu_to_be64s(&iq_cmd.cmd.u);
> -       iq_cmd.dptr =3D info->dptr_baddr;
> -       iq_cmd.rptr =3D 0;
> +       iq_cmd.dptr =3D info->dptr_baddr | info->gthr_sz << 60;
> +       iq_cmd.rptr =3D info->rptr_baddr | info->sctr_sz << 60;
>         iq_cmd.cptr.u =3D 0;
>         iq_cmd.cptr.s.grp =3D ctrl->s.grp;
>
> --
> 2.25.1
>
>
>

--=20
Regards,
Kalesh A P

--00000000000038e9b0060c377f60
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi=C2=A0Srujana,</div><div><br></div><div>Looks like =
you ignored my comments on V1 of your patch.</div><br><div class=3D"gmail_q=
uote"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Dec 11, 2023 at 12:50=
=E2=80=AFPM Srujana Challa &lt;<a href=3D"mailto:schalla@marvell.com" targe=
t=3D"_blank">schalla@marvell.com</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">Scatter Gather input format for CPT has ch=
anged on CN10KB/CN10KA B0 HW<br>
to make it comapatible with NIX Scatter Gather format to support SG mode<br=
>
for inline IPsec. This patch modifies the code to make the driver works<br>
for the same. This patch also enables CPT firmware load for these chips.<br=
>
<br>
Signed-off-by: Srujana Challa &lt;<a href=3D"mailto:schalla@marvell.com" ta=
rget=3D"_blank">schalla@marvell.com</a>&gt;<br>
---<br>
=C2=A0drivers/crypto/marvell/octeontx2/cn10k_cpt.c=C2=A0 |=C2=A0 19 +-<br>
=C2=A0drivers/crypto/marvell/octeontx2/cn10k_cpt.h=C2=A0 |=C2=A0 =C2=A01 +<=
br>
=C2=A0.../marvell/octeontx2/otx2_cpt_common.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 41 ++-<br>
=C2=A0.../marvell/octeontx2/otx2_cpt_hw_types.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 =
=C2=A03 +<br>
=C2=A0.../marvell/octeontx2/otx2_cpt_reqmgr.h=C2=A0 =C2=A0 =C2=A0 =C2=A0| 2=
93 ++++++++++++++++++<br>
=C2=A0drivers/crypto/marvell/octeontx2/otx2_cptlf.h |=C2=A0 =C2=A02 +<br>
=C2=A0.../marvell/octeontx2/otx2_cptpf_main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 26 +-<br>
=C2=A0.../marvell/octeontx2/otx2_cptpf_mbox.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 =C2=A02 +-<br>
=C2=A0.../marvell/octeontx2/otx2_cptpf_ucode.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =
33 +-<br>
=C2=A0.../marvell/octeontx2/otx2_cptpf_ucode.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =
=C2=A03 +-<br>
=C2=A0drivers/crypto/marvell/octeontx2/otx2_cptvf.h |=C2=A0 =C2=A02 +<br>
=C2=A0.../marvell/octeontx2/otx2_cptvf_main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 13 +<br>
=C2=A0.../marvell/octeontx2/otx2_cptvf_mbox.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 26 ++<br>
=C2=A0.../marvell/octeontx2/otx2_cptvf_reqmgr.c=C2=A0 =C2=A0 =C2=A0| 160 +-=
--------<br>
=C2=A014 files changed, 447 insertions(+), 177 deletions(-)<br>
<br>
diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c b/drivers/crypto/=
marvell/octeontx2/cn10k_cpt.c<br>
index 93d22b328991..b23ae3a020e0 100644<br>
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c<br>
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c<br>
@@ -14,12 +14,14 @@ static struct cpt_hw_ops otx2_hw_ops =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .send_cmd =3D otx2_cpt_send_cmd,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .cpt_get_compcode =3D otx2_cpt_get_compcode,<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .cpt_get_uc_compcode =3D otx2_cpt_get_uc_compco=
de,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0.cpt_sg_info_create =3D otx2_sg_info_create,<br=
>
=C2=A0};<br>
<br>
=C2=A0static struct cpt_hw_ops cn10k_hw_ops =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .send_cmd =3D cn10k_cpt_send_cmd,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .cpt_get_compcode =3D cn10k_cpt_get_compcode,<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 .cpt_get_uc_compcode =3D cn10k_cpt_get_uc_compc=
ode,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0.cpt_sg_info_create =3D otx2_sg_info_create,<br=
>
=C2=A0};<br>
<br>
=C2=A0static void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 in=
sts_num,<br>
@@ -78,12 +80,9 @@ int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct pci_dev *pdev =3D cptvf-&gt;pdev;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 resource_size_t offset, size;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!test_bit(CN10K_LMTST, &amp;cptvf-&gt;cap_f=
lag)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cptvf-&gt;lfs.ops =
=3D &amp;otx2_hw_ops;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!test_bit(CN10K_LMTST, &amp;cptvf-&gt;cap_f=
lag))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0cptvf-&gt;lfs.ops =3D &amp;cn10k_hw_ops;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 offset =3D pci_resource_start(pdev, PCI_MBOX_BA=
R_NUM);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 size =3D pci_resource_len(pdev, PCI_MBOX_BAR_NU=
M);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Map VF LMILINE region */<br>
@@ -96,3 +95,15 @@ int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
=C2=A0EXPORT_SYMBOL_NS_GPL(cn10k_cptvf_lmtst_init, CRYPTO_DEV_OCTEONTX2_CPT=
);<br>
+<br>
+int cptvf_hw_ops_get(struct otx2_cptvf_dev *cptvf)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!test_bit(CN10K_LMTST, &amp;cptvf-&gt;cap_f=
lag)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cptvf-&gt;lfs.ops =
=3D &amp;otx2_hw_ops;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cptvf-&gt;lfs.ops =3D &amp;cn10k_hw_ops;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+}<br>
+EXPORT_SYMBOL_NS_GPL(cptvf_hw_ops_get, CRYPTO_DEV_OCTEONTX2_CPT);<br></blo=
ckquote><div>[Kalesh]: You can make this function return void as it returns=
 0 always.</div><div>+void cptvf_hw_ops_get(struct otx2_cptvf_dev *cptvf)<b=
r>+{<br></div><div>+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!test_bit(CN10K_LMTST, &=
amp;cptvf-&gt;cap_flag))<br>+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0cptvf-&gt;lfs.ops =3D &amp;otx2_hw_ops;<br>+=C2=A0 =C2=A0 =C2=A0 =
=C2=A0else<br>+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cptvf=
-&gt;lfs.ops =3D &amp;cn10k_hw_ops;<br><a class=3D"gmail_plusreply" id=3D"m=
_-8923323482412406372plusReplyChip-0">+}</a><br></div><blockquote class=3D"=
gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(20=
4,204,204);padding-left:1ex">
diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h b/drivers/crypto/=
marvell/octeontx2/cn10k_cpt.h<br>
index aaefc7e38e06..0f714ee564f5 100644<br>
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h<br>
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h<br>
@@ -30,5 +30,6 @@ static inline u8 otx2_cpt_get_uc_compcode(union otx2_cpt_=
res_s *result)<br>
<br>
=C2=A0int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf);<br>
=C2=A0int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf);<br>
+int cptvf_hw_ops_get(struct otx2_cptvf_dev *cptvf);<br>
<br>
=C2=A0#endif /* __CN10K_CPTLF_H */<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/c=
rypto/marvell/octeontx2/otx2_cpt_common.h<br>
index 46b778bbbee4..2a7544252444 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h<br>
@@ -102,7 +102,10 @@ union otx2_cpt_eng_caps {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u64 kasumi:1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u64 des:1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u64 crc:1;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 reserved_14_63:=
50;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 mmul:1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 reserved_15_33:=
19;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 pdcp_chain:1;<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u64 reserved_35_63:=
29;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 };<br>
=C2=A0};<br>
<br>
@@ -145,6 +148,41 @@ static inline bool is_dev_otx2(struct pci_dev *pdev)<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;<br>
=C2=A0}<br>
<br>
+static inline bool is_dev_cn10ka(struct pci_dev *pdev)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pdev-&gt;subsystem_device =3D=3D CPT_PCI_SU=
BSYS_DEVID_CN10K_A)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+}<br></blockquote><div>[Kalesh]: You can further simply this as:</div><div=
>return pdev-&gt;subsystem_device =3D=3D CPT_PCI_SUBSYS_DEVID_CN10K_A=C2=A0=
</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;b=
order-left:1px solid rgb(204,204,204);padding-left:1ex">
+<br>
+static inline bool is_dev_cn10ka_ax(struct pci_dev *pdev)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pdev-&gt;subsystem_device =3D=3D CPT_PCI_SU=
BSYS_DEVID_CN10K_A &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0((pdev-&gt;revision &amp; 0xFF) =
=3D=3D 4 || (pdev-&gt;revision &amp; 0xFF) =3D=3D 0x50 ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (pdev-&gt;revision &amp; 0xff) =
=3D=3D 0x51))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+}<br>
+<br>
+static inline bool is_dev_cn10kb(struct pci_dev *pdev)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pdev-&gt;subsystem_device =3D=3D CPT_PCI_SU=
BSYS_DEVID_CN10K_B)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+}<br></blockquote><div>[Kalesh]: You can further simply this as:</div><div=
>return pdev-&gt;subsystem_device =3D=3D CPT_PCI_SUBSYS_DEVID_CN10K_B=C2=A0=
<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8=
ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
+<br>
+static inline bool is_dev_cn10ka_b0(struct pci_dev *pdev)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (pdev-&gt;subsystem_device =3D=3D CPT_PCI_SU=
BSYS_DEVID_CN10K_A &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(pdev-&gt;revision &amp; 0xFF) =
=3D=3D 0x54)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
+}<br>
+<br>
=C2=A0static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned=
 long *cap_flag)<br>
=C2=A0{<br>
@@ -154,7 +192,6 @@ static inline void otx2_cpt_set_hw_caps(struct pci_dev =
*pdev,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0}<br>
<br>
-<br></blockquote><div>[Kalesh]: This change looks unrelated=C2=A0</div><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t:1px solid rgb(204,204,204);padding-left:1ex">
=C2=A0int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *p=
dev);<br>
=C2=A0int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct pci_dev *pd=
ev);<br>
<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h b/drivers=
/crypto/marvell/octeontx2/otx2_cpt_hw_types.h<br>
index 6f947978e4e8..756aee0c2b05 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h<br>
@@ -13,6 +13,9 @@<br>
=C2=A0#define CN10K_CPT_PCI_PF_DEVICE_ID 0xA0F2<br>
=C2=A0#define CN10K_CPT_PCI_VF_DEVICE_ID 0xA0F3<br>
<br>
+#define CPT_PCI_SUBSYS_DEVID_CN10K_A 0xB900<br>
+#define CPT_PCI_SUBSYS_DEVID_CN10K_B 0xBD00<br>
+<br>
=C2=A0/* Mailbox interrupts offset */<br>
=C2=A0#define OTX2_CPT_PF_MBOX_INT=C2=A0 =C2=A06<br>
=C2=A0#define OTX2_CPT_PF_INT_VEC_E_MBOXX(x, a) ((x) + (a))<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/c=
rypto/marvell/octeontx2/otx2_cpt_reqmgr.h<br>
index dbb1ee746f4c..b0f426531a42 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h<br>
@@ -143,6 +143,8 @@ struct otx2_cpt_inst_info {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long time_in;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u32 dlen;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u32 dma_len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u64 gthr_sz;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u64 sctr_sz;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 extra_time;<br>
=C2=A0};<br>
<br>
@@ -157,6 +159,16 @@ struct otx2_cpt_sglist_component {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __be64 ptr3;<br>
=C2=A0};<br>
<br>
+struct cn10kb_cpt_sglist_component {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 len0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 len1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 len2;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 valid_segs;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u64 ptr0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u64 ptr1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u64 ptr2;<br>
+};<br>
+<br>
=C2=A0static inline void otx2_cpt_info_destroy(struct pci_dev *pdev,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0st=
ruct otx2_cpt_inst_info *info)<br>
=C2=A0{<br>
@@ -188,6 +200,287 @@ static inline void otx2_cpt_info_destroy(struct pci_d=
ev *pdev,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(info);<br>
=C2=A0}<br>
<br>
+static inline int setup_sgio_components(struct pci_dev *pdev,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ot=
x2_cpt_buf_ptr *list,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int buf_c=
ount, u8 *buffer)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cpt_sglist_component *sg_ptr =3D NU=
LL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0, i, j;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int components;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!list)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Input list pointer is NULL\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EFAULT;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; buf_count; i++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!list[=
i].vptr))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list[i].dma_addr =
=3D dma_map_single(&amp;pdev-&gt;dev, list[i].vptr,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0list[i].size,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0DMA_BIDIRECTIONAL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(dma_ma=
pping_error(&amp;pdev-&gt;dev, list[i].dma_addr))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dev_err(&amp;pdev-&gt;dev, &quot;Dma mapping failed\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ret =3D -EIO;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto sg_cleanup;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0components =3D buf_count / 4;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr =3D (struct otx2_cpt_sglist_component *)=
buffer;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; components; i++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len0 =3D=
 cpu_to_be16(list[i * 4 + 0].size);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len1 =3D=
 cpu_to_be16(list[i * 4 + 1].size);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len2 =3D=
 cpu_to_be16(list[i * 4 + 2].size);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len3 =3D=
 cpu_to_be16(list[i * 4 + 3].size);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr0 =3D=
 cpu_to_be64(list[i * 4 + 0].dma_addr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr1 =3D=
 cpu_to_be64(list[i * 4 + 1].dma_addr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr2 =3D=
 cpu_to_be64(list[i * 4 + 2].dma_addr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr3 =3D=
 cpu_to_be64(list[i * 4 + 3].dma_addr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr++;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0components =3D buf_count % 4;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0switch (components) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0case 3:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len2 =3D=
 cpu_to_be16(list[i * 4 + 2].size);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr2 =3D=
 cpu_to_be64(list[i * 4 + 2].dma_addr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fallthrough;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0case 2:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len1 =3D=
 cpu_to_be16(list[i * 4 + 1].size);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr1 =3D=
 cpu_to_be64(list[i * 4 + 1].dma_addr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fallthrough;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0case 1:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len0 =3D=
 cpu_to_be16(list[i * 4 + 0].size);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr0 =3D=
 cpu_to_be64(list[i * 4 + 0].dma_addr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0default:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
+<br>
+sg_cleanup:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (j =3D 0; j &lt; i; j++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (list[j].dma_add=
r) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dma_unmap_single(&amp;pdev-&gt;dev, list[j].dma_addr,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list[j].=
size, DMA_BIDIRECTIONAL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list[j].dma_addr =
=3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
+}<br>
+<br>
+static inline int sgv2io_components_setup(struct pci_dev *pdev,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0st=
ruct otx2_cpt_buf_ptr *list,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in=
t buf_count, u8 *buffer)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct cn10kb_cpt_sglist_component *sg_ptr =3D =
NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0, i, j;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int components;<br></blockquote><div>[Kalesh]: =
maintain RCT order=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:=
1ex">
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!list)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Input list pointer is NULL\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EFAULT;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; buf_count; i++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!list[=
i].vptr))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list[i].dma_addr =
=3D dma_map_single(&amp;pdev-&gt;dev, list[i].vptr,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0list[i].size,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0DMA_BIDIRECTIONAL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(dma_ma=
pping_error(&amp;pdev-&gt;dev, list[i].dma_addr))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dev_err(&amp;pdev-&gt;dev, &quot;Dma mapping failed\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ret =3D -EIO;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto sg_cleanup;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0components =3D buf_count / 3;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr =3D (struct cn10kb_cpt_sglist_component =
*)buffer;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; components; i++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len0 =3D=
 list[i * 3 + 0].size;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len1 =3D=
 list[i * 3 + 1].size;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len2 =3D=
 list[i * 3 + 2].size;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr0 =3D=
 list[i * 3 + 0].dma_addr;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr1 =3D=
 list[i * 3 + 1].dma_addr;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr2 =3D=
 list[i * 3 + 2].dma_addr;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;valid_se=
gs =3D 3;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr++;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0components =3D buf_count % 3;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;valid_segs =3D components;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0switch (components) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0case 2:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len1 =3D=
 list[i * 3 + 1].size;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr1 =3D=
 list[i * 3 + 1].dma_addr;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fallthrough;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0case 1:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len0 =3D=
 list[i * 3 + 0].size;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr0 =3D=
 list[i * 3 + 0].dma_addr;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0default:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
+<br>
+sg_cleanup:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (j =3D 0; j &lt; i; j++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (list[j].dma_add=
r) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dma_unmap_single(&amp;pdev-&gt;dev, list[j].dma_addr,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list[j].=
size, DMA_BIDIRECTIONAL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list[j].dma_addr =
=3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
+}<br>
+<br>
+static inline struct otx2_cpt_inst_info *cn10k_sgv2_info_create(<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct pci_dev *pdev,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct otx2_cpt_req_info *req,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0gfp_t gfp)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 dlen =3D 0, g_len, sg_len, info_len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int align =3D OTX2_CPT_DMA_MINALIGN;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cpt_inst_info *info;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 g_sz_bytes, s_sz_bytes;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 total_mem_len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0g_sz_bytes =3D ((req-&gt;in_cnt + 2) / 3) *<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0sizeof(struct cn10kb_cpt_sglist_component);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0s_sz_bytes =3D ((req-&gt;out_cnt + 2) / 3) *<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0sizeof(struct cn10kb_cpt_sglist_component);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0g_len =3D ALIGN(g_sz_bytes, align);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0sg_len =3D ALIGN(g_len + s_sz_bytes, align);<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info_len =3D ALIGN(sizeof(*info), align);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0total_mem_len =3D sg_len + info_len + sizeof(un=
ion otx2_cpt_res_s);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info =3D kzalloc(total_mem_len, gfp);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!info))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; req-&gt;in_cnt; i++)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dlen +=3D req-&gt;i=
n[i].size;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dlen =3D dlen;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;in_buffer =3D (u8 *)info + info_len;<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;gthr_sz =3D req-&gt;in_cnt;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;sctr_sz =3D req-&gt;out_cnt;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Setup gather (input) components */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sgv2io_components_setup(pdev, req-&gt;in, r=
eq-&gt;in_cnt,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;in_buffer)) {<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Failed to setup gather list\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto destroy_info;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sgv2io_components_setup(pdev, req-&gt;out, =
req-&gt;out_cnt,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;info-&gt;in_buffer=
[g_len])) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Failed to setup scatter list\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto destroy_info;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dma_len =3D total_mem_len - info_len;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dptr_baddr =3D dma_map_single(&amp;pde=
v-&gt;dev, info-&gt;in_buffer,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in=
fo-&gt;dma_len, DMA_BIDIRECTIONAL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(dma_mapping_error(&amp;pdev-&gt;de=
v, info-&gt;dptr_baddr))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;DMA Mapping failed for cpt req\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto destroy_info;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;rptr_baddr =3D info-&gt;dptr_baddr + g=
_len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Get buffer for union otx2_cpt_res_s response=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * structure and its physical address<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;completion_addr =3D info-&gt;in_buffer=
 + sg_len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;comp_baddr =3D info-&gt;dptr_baddr + s=
g_len;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return info;<br>
+<br>
+destroy_info:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0otx2_cpt_info_destroy(pdev, info);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+}<br>
+<br>
+/* SG list header size in bytes */<br>
+#define SG_LIST_HDR_SIZE=C2=A0 =C2=A0 =C2=A0 =C2=A08<br>
+static inline struct otx2_cpt_inst_info *otx2_sg_info_create(<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct pci_dev *pdev,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct otx2_cpt_req_info *req,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0gfp_t gfp)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int align =3D OTX2_CPT_DMA_MINALIGN;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cpt_inst_info *info;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 dlen, align_dlen, info_len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 g_sz_bytes, s_sz_bytes;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 total_mem_len;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(req-&gt;in_cnt &gt; OTX2_CPT_MAX_S=
G_IN_CNT ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req-=
&gt;out_cnt &gt; OTX2_CPT_MAX_SG_OUT_CNT)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Error too many sg components\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0g_sz_bytes =3D ((req-&gt;in_cnt + 3) / 4) *<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0sizeof(struct otx2_cpt_sglist_component);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0s_sz_bytes =3D ((req-&gt;out_cnt + 3) / 4) *<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0sizeof(struct otx2_cpt_sglist_component);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0dlen =3D g_sz_bytes + s_sz_bytes + SG_LIST_HDR_=
SIZE;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0align_dlen =3D ALIGN(dlen, align);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info_len =3D ALIGN(sizeof(*info), align);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0total_mem_len =3D align_dlen + info_len + sizeo=
f(union otx2_cpt_res_s);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info =3D kzalloc(total_mem_len, gfp);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!info))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dlen =3D dlen;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;in_buffer =3D (u8 *)info + info_len;<b=
r>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0((u16 *)info-&gt;in_buffer)[0] =3D req-&gt;out_=
cnt;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0((u16 *)info-&gt;in_buffer)[1] =3D req-&gt;in_c=
nt;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0((u16 *)info-&gt;in_buffer)[2] =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0((u16 *)info-&gt;in_buffer)[3] =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to_be64s((u64 *)info-&gt;in_buffer);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Setup gather (input) components */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (setup_sgio_components(pdev, req-&gt;in, req=
-&gt;in_cnt,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;info-&gt;in_buffer[8])) {=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Failed to setup gather list\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto destroy_info;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (setup_sgio_components(pdev, req-&gt;out, re=
q-&gt;out_cnt,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;info-&gt;in_buffer[8 + g_=
sz_bytes])) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Failed to setup scatter list\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto destroy_info;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dma_len =3D total_mem_len - info_len;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dptr_baddr =3D dma_map_single(&amp;pde=
v-&gt;dev, info-&gt;in_buffer,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in=
fo-&gt;dma_len, DMA_BIDIRECTIONAL);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(dma_mapping_error(&amp;pdev-&gt;de=
v, info-&gt;dptr_baddr))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;DMA Mapping failed for cpt req\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto destroy_info;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Get buffer for union otx2_cpt_res_s response=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * structure and its physical address<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;completion_addr =3D info-&gt;in_buffer=
 + align_dlen;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;comp_baddr =3D info-&gt;dptr_baddr + a=
lign_dlen;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return info;<br>
+<br>
+destroy_info:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0otx2_cpt_info_destroy(pdev, info);<br></blockqu=
ote><div>[Kalesh]&quot; Where is the memory allocated for &quot;info&quot; =
getting freed. The memory is allocated locally inside this function.</div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft:1px solid rgb(204,204,204);padding-left:1ex">
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
+}<br>
+<br>
=C2=A0struct otx2_cptlf_wqe;<br>
=C2=A0int otx2_cpt_do_request(struct pci_dev *pdev, struct otx2_cpt_req_inf=
o *req,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 int cpu_num);<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto=
/marvell/octeontx2/otx2_cptlf.h<br>
index 5302fe3d0e6f..70138d65ba9e 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h<br>
@@ -99,6 +99,8 @@ struct cpt_hw_ops {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0struct otx2_cptlf_info *lf);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 (*cpt_get_compcode)(union otx2_cpt_res_s *re=
sult);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 (*cpt_get_uc_compcode)(union otx2_cpt_res_s =
*result);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cpt_inst_info * (*cpt_sg_info_creat=
e)(struct pci_dev *pdev,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct otx2_cpt_req_in=
fo *req, gfp_t gfp);<br>
=C2=A0};<br>
<br>
=C2=A0struct otx2_cptlfs_info {<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/c=
rypto/marvell/octeontx2/otx2_cptpf_main.c<br>
index 5436b0d3685c..c64c50a964ed 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c<br>
@@ -14,6 +14,8 @@<br>
=C2=A0#define OTX2_CPT_DRV_STRING=C2=A0 &quot;Marvell RVU CPT Physical Func=
tion Driver&quot;<br>
<br>
=C2=A0#define CPT_UC_RID_CN9K_B0=C2=A0 =C2=A01<br>
+#define CPT_UC_RID_CN10K_A=C2=A0 =C2=A04<br>
+#define CPT_UC_RID_CN10K_B=C2=A0 =C2=A05<br>
<br>
=C2=A0static void cptpf_enable_vfpf_mbox_intr(struct otx2_cptpf_dev *cptpf,=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int num_=
vfs)<br>
@@ -587,6 +589,26 @@ static int cpt_is_pf_usable(struct otx2_cptpf_dev *cpt=
pf)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
+static int cptpf_get_rid(struct pci_dev *pdev, struct otx2_cptpf_dev *cptp=
f)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cpt_eng_grps *eng_grps =3D &amp;cpt=
pf-&gt;eng_grps;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u64 reg_val =3D 0x0;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (is_dev_otx2(pdev)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0eng_grps-&gt;rid =
=3D pdev-&gt;revision;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0otx2_cpt_read_af_reg(&amp;cptpf-&gt;afpf_mbox, =
pdev, CPT_AF_CTL, &amp;reg_val,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 BLKADDR_CPT0);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((is_dev_cn10ka_b0(pdev) &amp;&amp; (reg_val=
 &amp; BIT_ULL(18))) ||<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0is_dev_cn10ka_ax(pdev))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0eng_grps-&gt;rid =
=3D CPT_UC_RID_CN10K_A;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0else if (is_dev_cn10kb(pdev) || is_dev_cn10ka_b=
0(pdev))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0eng_grps-&gt;rid =
=3D CPT_UC_RID_CN10K_B;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+}<br></blockquote><div>[Kalesh]: You can convert this function to return v=
oid as it always returns 0 always.</div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);pad=
ding-left:1ex">
+<br>
=C2=A0static void cptpf_check_block_implemented(struct otx2_cptpf_dev *cptp=
f)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u64 cfg;<br>
@@ -657,7 +679,9 @@ static int cptpf_sriov_enable(struct pci_dev *pdev, int=
 num_vfs)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D cptpf_register_vfpf_intr(cptpf, num_vfs=
);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto destroy_flr;<b=
r>
-<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D cptpf_get_rid(pdev, cptpf);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto disable_intr;<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Get CPT HW capabilities using LOAD_FVC opera=
tion. */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D otx2_cpt_discover_eng_capabilities(cptp=
f);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/c=
rypto/marvell/octeontx2/otx2_cptpf_mbox.c<br>
index 480b3720f15a..390ed146d309 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c<br>
@@ -78,7 +78,7 @@ static int handle_msg_get_caps(struct otx2_cptpf_dev *cpt=
pf,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rsp-&gt;hdr.sig =3D OTX2_MBOX_RSP_SIG;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rsp-&gt;hdr.pcifunc =3D req-&gt;pcifunc;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rsp-&gt;cpt_pf_drv_version =3D OTX2_CPT_PF_DRV_=
VERSION;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0rsp-&gt;cpt_revision =3D cptpf-&gt;pdev-&gt;rev=
ision;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0rsp-&gt;cpt_revision =3D cptpf-&gt;eng_grps.rid=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(&amp;rsp-&gt;eng_caps, &amp;cptpf-&gt;en=
g_caps, sizeof(rsp-&gt;eng_caps));<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/=
crypto/marvell/octeontx2/otx2_cptpf_ucode.c<br>
index 1958b797a421..7fccc348f66e 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c<br>
@@ -117,12 +117,10 @@ static char *get_ucode_type_str(int ucode_type)<br>
<br>
=C2=A0static int get_ucode_type(struct device *dev,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 struct otx2_cpt_ucode_hdr *ucode_hdr,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0int *ucode_type)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0int *ucode_type, u16 rid)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cptpf_dev *cptpf =3D dev_get_drvdat=
a(dev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char ver_str_prefix[OTX2_CPT_UCODE_VER_STR_SZ];=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char tmp_ver_str[OTX2_CPT_UCODE_VER_STR_SZ];<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct pci_dev *pdev =3D cptpf-&gt;pdev;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, val =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 nn;<br>
<br>
@@ -130,7 +128,7 @@ static int get_ucode_type(struct device *dev,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; strlen(tmp_ver_str); i++)<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tmp_ver_str[i] =3D =
tolower(tmp_ver_str[i]);<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0sprintf(ver_str_prefix, &quot;ocpt-%02d&quot;, =
pdev-&gt;revision);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0sprintf(ver_str_prefix, &quot;ocpt-%02d&quot;, =
rid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!strnstr(tmp_ver_str, ver_str_prefix, OTX2_=
CPT_UCODE_VER_STR_SZ))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;<br>
<br>
@@ -359,7 +357,7 @@ static int cpt_attach_and_enable_cores(struct otx2_cpt_=
eng_grp_info *eng_grp,<br>
=C2=A0}<br>
<br>
=C2=A0static int load_fw(struct device *dev, struct fw_info_t *fw_info,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char *filen=
ame)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char *filen=
ame, u16 rid)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct otx2_cpt_ucode_hdr *ucode_hdr;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct otx2_cpt_uc_info_t *uc_info;<br>
@@ -375,7 +373,7 @@ static int load_fw(struct device *dev, struct fw_info_t=
 *fw_info,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto free_uc_info;<=
br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ucode_hdr =3D (struct otx2_cpt_ucode_hdr *)uc_i=
nfo-&gt;fw-&gt;data;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D get_ucode_type(dev, ucode_hdr, &amp;uco=
de_type);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D get_ucode_type(dev, ucode_hdr, &amp;uco=
de_type, rid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto release_fw;<br=
>
<br>
@@ -389,6 +387,7 @@ static int load_fw(struct device *dev, struct fw_info_t=
 *fw_info,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 set_ucode_filename(&amp;uc_info-&gt;ucode, file=
name);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(uc_info-&gt;ucode.ver_str, ucode_hdr-&gt=
;ver_str,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0OTX2_CPT_UCODE_VER_S=
TR_SZ);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0uc_info-&gt;ucode.ver_str[OTX2_CPT_UCODE_VER_ST=
R_SZ] =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uc_info-&gt;ucode.ver_num =3D ucode_hdr-&gt;ver=
_num;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uc_info-&gt;ucode.type =3D ucode_type;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uc_info-&gt;ucode.size =3D ucode_size;<br>
@@ -448,7 +447,8 @@ static void print_uc_info(struct fw_info_t *fw_info)<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0}<br>
<br>
-static int cpt_ucode_load_fw(struct pci_dev *pdev, struct fw_info_t *fw_in=
fo)<br>
+static int cpt_ucode_load_fw(struct pci_dev *pdev, struct fw_info_t *fw_in=
fo,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 u16 rid)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char filename[OTX2_CPT_NAME_LENGTH];<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char eng_type[8] =3D {0};<br>
@@ -462,9 +462,9 @@ static int cpt_ucode_load_fw(struct pci_dev *pdev, stru=
ct fw_info_t *fw_info)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 eng_type[i] =3D tolower(eng_type[i]);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 snprintf(filename, =
sizeof(filename), &quot;mrvl/cpt%02d/%s.out&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 pdev-&gt;revision, eng_type);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rid, eng_type);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Request firmware=
 for each engine type */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D load_fw(&am=
p;pdev-&gt;dev, fw_info, filename);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D load_fw(&am=
p;pdev-&gt;dev, fw_info, filename, rid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto release_fw;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
@@ -1155,7 +1155,7 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *c=
ptpf,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (eng_grps-&gt;is_grps_created)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto unlock;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D cpt_ucode_load_fw(pdev, &amp;fw_info);<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D cpt_ucode_load_fw(pdev, &amp;fw_info, e=
ng_grps-&gt;rid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto unlock;<br>
<br>
@@ -1230,14 +1230,16 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev =
*cptpf,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rnm_to_cpt_errata_fixup(&amp;pdev-&gt;dev);<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0otx2_cpt_read_af_reg(&amp;cptpf-&gt;afpf_mbox, =
pdev, CPT_AF_CTL, &amp;reg_val,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 BLKADDR_CPT0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Configure engine group mask to allow co=
ntext prefetching<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* for the groups and enable random number=
 request, to enable<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* CPT to request random numbers from RNM.=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0reg_val |=3D OTX2_CPT_ALL_ENG_GRPS_MASK &lt;&lt=
; 3 | BIT_ULL(16);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 otx2_cpt_write_af_reg(&amp;cptpf-&gt;afpf_mbox,=
 pdev, CPT_AF_CTL,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0OTX2_CPT_ALL_ENG_GRPS_MASK &lt;&lt; 3 | BIT_=
ULL(16),<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BLKADDR_CPT0);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reg_val, BLKADDR_CPT0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Set interval to periodically flush dirt=
y data for the next<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* CTX cache entry. Set the interval count=
 to maximum supported<br>
@@ -1412,7 +1414,7 @@ static int create_eng_caps_discovery_grps(struct pci_=
dev *pdev,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_lock(&amp;eng_grps-&gt;lock);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D cpt_ucode_load_fw(pdev, &amp;fw_info);<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D cpt_ucode_load_fw(pdev, &amp;fw_info, e=
ng_grps-&gt;rid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&amp;e=
ng_grps-&gt;lock);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;<br>
@@ -1686,13 +1688,14 @@ int otx2_cpt_dl_custom_egrp_create(struct otx2_cptp=
f_dev *cptpf,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err_unlock;<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&amp;fw_info.ucodes);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D load_fw(dev, &amp;fw_info, ucode_filena=
me[0]);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D load_fw(dev, &amp;fw_info, ucode_filena=
me[0], eng_grps-&gt;rid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dev_err(dev, &quot;=
Unable to load firmware %s\n&quot;, ucode_filename[0]);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto err_unlock;<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ucode_idx &gt; 1) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D load_fw(dev=
, &amp;fw_info, ucode_filename[1]);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D load_fw(dev=
, &amp;fw_info, ucode_filename[1], eng_grps-&gt;rid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 dev_err(dev, &quot;Unable to load firmware %s\n&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ucode_filename[1]);<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h b/drivers/=
crypto/marvell/octeontx2/otx2_cptpf_ucode.h<br>
index e69320a54b5d..365fe8943bd9 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h<br>
@@ -73,7 +73,7 @@ struct otx2_cpt_ucode_hdr {<br>
=C2=A0};<br>
<br>
=C2=A0struct otx2_cpt_ucode {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 ver_str[OTX2_CPT_UCODE_VER_STR_SZ];/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 ver_str[OTX2_CPT_UCODE_VER_STR_SZ + 1];/*<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0* ucode version in readable<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0* format<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0*/<br>
@@ -150,6 +150,7 @@ struct otx2_cpt_eng_grps {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int engs_num;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* total number of engines supported */<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 eng_ref_cnt[OTX2_CPT_MAX_ENGINES];/* engines=
 reference count */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 bool is_grps_created; /* Is the engine groups a=
re already created */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 rid;<br>
=C2=A0};<br>
=C2=A0struct otx2_cptpf_dev;<br>
=C2=A0int otx2_cpt_init_eng_grps(struct pci_dev *pdev,<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h b/drivers/crypto=
/marvell/octeontx2/otx2_cptvf.h<br>
index 994291e90da1..11ab9af1df15 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf.h<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf.h<br>
@@ -22,6 +22,7 @@ struct otx2_cptvf_dev {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int blkaddr;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 void *bbuf_base;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long cap_flag;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0u64 eng_caps[OTX2_CPT_MAX_ENG_TYPES];<br>
=C2=A0};<br>
<br>
=C2=A0irqreturn_t otx2_cptvf_pfvf_mbox_intr(int irq, void *arg);<br>
@@ -29,5 +30,6 @@ void otx2_cptvf_pfvf_mbox_handler(struct work_struct *wor=
k);<br>
=C2=A0int otx2_cptvf_send_eng_grp_num_msg(struct otx2_cptvf_dev *cptvf, int=
 eng_type);<br>
=C2=A0int otx2_cptvf_send_kvf_limits_msg(struct otx2_cptvf_dev *cptvf);<br>
=C2=A0int otx2_cpt_mbox_bbuf_init(struct otx2_cptvf_dev *cptvf, struct pci_=
dev *pdev);<br>
+int otx2_cptvf_send_caps_msg(struct otx2_cptvf_dev *cptvf);<br>
<br>
=C2=A0#endif /* __OTX2_CPTVF_H */<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/c=
rypto/marvell/octeontx2/otx2_cptvf_main.c<br>
index bac729c885f9..5d1e11135c17 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c<br>
@@ -380,6 +380,19 @@ static int otx2_cptvf_probe(struct pci_dev *pdev,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto destroy_pfvf_m=
box;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 cptvf-&gt;blkaddr =3D BLKADDR_CPT0;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D cptvf_hw_ops_get(cptvf);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto unregister_int=
errupts;<br></blockquote><div>[Kalesh]: No need to check return value here.=
 See my other comment above.=C2=A0</div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);pad=
ding-left:1ex">
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D otx2_cptvf_send_caps_msg(cptvf);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Couldn&#39;t get CPT engine capabilities.\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto unregister_int=
errupts;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (cptvf-&gt;eng_caps[OTX2_CPT_SE_TYPES] &amp;=
 BIT_ULL(35))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cptvf-&gt;lfs.ops-&=
gt;cpt_sg_info_create =3D cn10k_sgv2_info_create;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Initialize CPT LFs */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D cptvf_lf_init(cptvf);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c b/drivers/c=
rypto/marvell/octeontx2/otx2_cptvf_mbox.c<br>
index 75c403f2b1d9..f68da1d08fdf 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c<br>
@@ -72,6 +72,7 @@ static void process_pfvf_mbox_mbox_msg(struct otx2_cptvf_=
dev *cptvf,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct otx2_cptlfs_info *lfs =3D &amp;cptvf-&gt=
;lfs;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct otx2_cpt_kvf_limits_rsp *rsp_limits;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct otx2_cpt_egrp_num_rsp *rsp_grp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cpt_caps_rsp *eng_caps;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cpt_rd_wr_reg_msg *rsp_reg;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct msix_offset_rsp *rsp_msix;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
@@ -127,6 +128,11 @@ static void process_pfvf_mbox_mbox_msg(struct otx2_cpt=
vf_dev *cptvf,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rsp_limits =3D (str=
uct otx2_cpt_kvf_limits_rsp *) msg;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cptvf-&gt;lfs.kvf_l=
imits =3D rsp_limits-&gt;kvf_limits;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0case MBOX_MSG_GET_CAPS:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0eng_caps =3D (struc=
t otx2_cpt_caps_rsp *)msg;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(cptvf-&gt;en=
g_caps, eng_caps-&gt;eng_caps,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 sizeof(cptvf-&gt;eng_caps));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 default:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dev_err(&amp;cptvf-=
&gt;pdev-&gt;dev, &quot;Unsupported msg %d received.\n&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 msg-&gt;id);<br>
@@ -205,3 +211,23 @@ int otx2_cptvf_send_kvf_limits_msg(struct otx2_cptvf_d=
ev *cptvf)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return otx2_cpt_send_mbox_msg(mbox, pdev);<br>
=C2=A0}<br>
+<br>
+int otx2_cptvf_send_caps_msg(struct otx2_cptvf_dev *cptvf)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_mbox *mbox =3D &amp;cptvf-&gt;pfvf_=
mbox;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct pci_dev *pdev =3D cptvf-&gt;pdev;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct mbox_msghdr *req;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0req =3D (struct mbox_msghdr *)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0otx2_mbox_alloc_msg_rsp(mb=
ox, 0, sizeof(*req),<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sizeof(struct ot=
x2_cpt_caps_rsp));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!req) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;RVU MBOX failed to get message.\n&quot;);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EFAULT;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0req-&gt;id =3D MBOX_MSG_GET_CAPS;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0req-&gt;sig =3D OTX2_MBOX_REQ_SIG;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0req-&gt;pcifunc =3D OTX2_CPT_RVU_PFFUNC(cptvf-&=
gt;vf_id, 0);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return otx2_cpt_send_mbox_msg(mbox, pdev);<br>
+}<br>
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers=
/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c<br>
index 811ded72ce5f..997a2eb60c66 100644<br>
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c<br>
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c<br>
@@ -4,9 +4,6 @@<br>
=C2=A0#include &quot;otx2_cptvf.h&quot;<br>
=C2=A0#include &quot;otx2_cpt_common.h&quot;<br>
<br>
-/* SG list header size in bytes */<br>
-#define SG_LIST_HDR_SIZE=C2=A0 =C2=A0 =C2=A0 =C2=A08<br>
-<br>
=C2=A0/* Default timeout when waiting for free pending entry in us */<br>
=C2=A0#define CPT_PENTRY_TIMEOUT=C2=A0 =C2=A0 =C2=A01000<br>
=C2=A0#define CPT_PENTRY_STEP=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 50<br>
@@ -26,9 +23,9 @@ static void otx2_cpt_dump_sg_list(struct pci_dev *pdev,<b=
r>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_debug(&quot;Gather list size %d\n&quot;, req=
-&gt;in_cnt);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; req-&gt;in_cnt; i++) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_debug(&quot;Buff=
er %d size %d, vptr 0x%p, dmaptr 0x%p\n&quot;, i,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_debug(&quot;Buff=
er %d size %d, vptr 0x%p, dmaptr 0x%llx\n&quot;, i,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0req-&gt;in[i].size, req-&gt;in[i].vptr,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (void *) req-&gt;in[i].dma_addr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 req-&gt;in[i].dma_addr);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_debug(&quot;Buff=
er hexdump (%d bytes)\n&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0req-&gt;in[i].size);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 print_hex_dump_debu=
g(&quot;&quot;, DUMP_PREFIX_NONE, 16, 1,<br>
@@ -36,9 +33,9 @@ static void otx2_cpt_dump_sg_list(struct pci_dev *pdev,<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_debug(&quot;Scatter list size %d\n&quot;, re=
q-&gt;out_cnt);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; req-&gt;out_cnt; i++) {<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_debug(&quot;Buff=
er %d size %d, vptr 0x%p, dmaptr 0x%p\n&quot;, i,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_debug(&quot;Buff=
er %d size %d, vptr 0x%p, dmaptr 0x%llx\n&quot;, i,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0req-&gt;out[i].size, req-&gt;out[i].vptr,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (void *) req-&gt;out[i].dma_addr);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 req-&gt;out[i].dma_addr);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_debug(&quot;Buff=
er hexdump (%d bytes)\n&quot;, req-&gt;out[i].size);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 print_hex_dump_debu=
g(&quot;&quot;, DUMP_PREFIX_NONE, 16, 1,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0req-&gt;out[i].v=
ptr, req-&gt;out[i].size, false);<br>
@@ -84,149 +81,6 @@ static inline void free_pentry(struct otx2_cpt_pending_=
entry *pentry)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pentry-&gt;busy =3D false;<br>
=C2=A0}<br>
<br>
-static inline int setup_sgio_components(struct pci_dev *pdev,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ot=
x2_cpt_buf_ptr *list,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int buf_c=
ount, u8 *buffer)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cpt_sglist_component *sg_ptr =3D NU=
LL;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0, i, j;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int components;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!list)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Input list pointer is NULL\n&quot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EFAULT;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; buf_count; i++) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!list[=
i].vptr))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list[i].dma_addr =
=3D dma_map_single(&amp;pdev-&gt;dev, list[i].vptr,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0list[i].size,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0DMA_BIDIRECTIONAL);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(dma_ma=
pping_error(&amp;pdev-&gt;dev, list[i].dma_addr))) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dev_err(&amp;pdev-&gt;dev, &quot;Dma mapping failed\n&quot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ret =3D -EIO;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto sg_cleanup;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0components =3D buf_count / 4;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr =3D (struct otx2_cpt_sglist_component *)=
buffer;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; components; i++) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len0 =3D=
 cpu_to_be16(list[i * 4 + 0].size);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len1 =3D=
 cpu_to_be16(list[i * 4 + 1].size);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len2 =3D=
 cpu_to_be16(list[i * 4 + 2].size);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len3 =3D=
 cpu_to_be16(list[i * 4 + 3].size);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr0 =3D=
 cpu_to_be64(list[i * 4 + 0].dma_addr);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr1 =3D=
 cpu_to_be64(list[i * 4 + 1].dma_addr);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr2 =3D=
 cpu_to_be64(list[i * 4 + 2].dma_addr);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr3 =3D=
 cpu_to_be64(list[i * 4 + 3].dma_addr);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr++;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0components =3D buf_count % 4;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0switch (components) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0case 3:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len2 =3D=
 cpu_to_be16(list[i * 4 + 2].size);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr2 =3D=
 cpu_to_be64(list[i * 4 + 2].dma_addr);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fallthrough;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0case 2:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len1 =3D=
 cpu_to_be16(list[i * 4 + 1].size);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr1 =3D=
 cpu_to_be64(list[i * 4 + 1].dma_addr);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fallthrough;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0case 1:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;len0 =3D=
 cpu_to_be16(list[i * 4 + 0].size);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sg_ptr-&gt;ptr0 =3D=
 cpu_to_be64(list[i * 4 + 0].dma_addr);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0default:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
-<br>
-sg_cleanup:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (j =3D 0; j &lt; i; j++) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (list[j].dma_add=
r) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dma_unmap_single(&amp;pdev-&gt;dev, list[j].dma_addr,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list[j].=
size, DMA_BIDIRECTIONAL);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list[j].dma_addr =
=3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
-}<br>
-<br>
-static inline struct otx2_cpt_inst_info *info_create(struct pci_dev *pdev,=
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct otx2_cpt_req_info *req,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0gfp_t gfp)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int align =3D OTX2_CPT_DMA_MINALIGN;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cpt_inst_info *info;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 dlen, align_dlen, info_len;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 g_sz_bytes, s_sz_bytes;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 total_mem_len;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(req-&gt;in_cnt &gt; OTX2_CPT_MAX_S=
G_IN_CNT ||<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req-=
&gt;out_cnt &gt; OTX2_CPT_MAX_SG_OUT_CNT)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Error too many sg components\n&quot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0g_sz_bytes =3D ((req-&gt;in_cnt + 3) / 4) *<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0sizeof(struct otx2_cpt_sglist_component);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0s_sz_bytes =3D ((req-&gt;out_cnt + 3) / 4) *<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0sizeof(struct otx2_cpt_sglist_component);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0dlen =3D g_sz_bytes + s_sz_bytes + SG_LIST_HDR_=
SIZE;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0align_dlen =3D ALIGN(dlen, align);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0info_len =3D ALIGN(sizeof(*info), align);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0total_mem_len =3D align_dlen + info_len + sizeo=
f(union otx2_cpt_res_s);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0info =3D kzalloc(total_mem_len, gfp);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!info))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dlen =3D dlen;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;in_buffer =3D (u8 *)info + info_len;<b=
r>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0((u16 *)info-&gt;in_buffer)[0] =3D req-&gt;out_=
cnt;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0((u16 *)info-&gt;in_buffer)[1] =3D req-&gt;in_c=
nt;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0((u16 *)info-&gt;in_buffer)[2] =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0((u16 *)info-&gt;in_buffer)[3] =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to_be64s((u64 *)info-&gt;in_buffer);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Setup gather (input) components */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (setup_sgio_components(pdev, req-&gt;in, req=
-&gt;in_cnt,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;info-&gt;in_buffer[8])) {=
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Failed to setup gather list\n&quot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto destroy_info;<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (setup_sgio_components(pdev, req-&gt;out, re=
q-&gt;out_cnt,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;info-&gt;in_buffer[8 + g_=
sz_bytes])) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;Failed to setup scatter list\n&quot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto destroy_info;<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dma_len =3D total_mem_len - info_len;<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;dptr_baddr =3D dma_map_single(&amp;pde=
v-&gt;dev, info-&gt;in_buffer,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in=
fo-&gt;dma_len, DMA_BIDIRECTIONAL);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(dma_mapping_error(&amp;pdev-&gt;de=
v, info-&gt;dptr_baddr))) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;pdev-&=
gt;dev, &quot;DMA Mapping failed for cpt req\n&quot;);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto destroy_info;<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Get buffer for union otx2_cpt_res_s response=
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * structure and its physical address<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;completion_addr =3D info-&gt;in_buffer=
 + align_dlen;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0info-&gt;comp_baddr =3D info-&gt;dptr_baddr + a=
lign_dlen;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return info;<br>
-<br>
-destroy_info:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0otx2_cpt_info_destroy(pdev, info);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
-}<br>
-<br>
=C2=A0static int process_request(struct pci_dev *pdev, struct otx2_cpt_req_=
info *req,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cpt_pending_queue *pqueue,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0struct otx2_cptlf_info *lf)<br>
@@ -247,7 +101,7 @@ static int process_request(struct pci_dev *pdev, struct=
 otx2_cpt_req_info *req,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(!otx2_cptlf_started(lf-&gt;lfs)))<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENODEV;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0info =3D info_create(pdev, req, gfp);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0info =3D lf-&gt;lfs-&gt;ops-&gt;cpt_sg_info_cre=
ate(pdev, req, gfp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(!info)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dev_err(&amp;pdev-&=
gt;dev, &quot;Setting up cpt inst info failed&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;<br>
@@ -303,8 +157,8 @@ static int process_request(struct pci_dev *pdev, struct=
 otx2_cpt_req_info *req,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* 64-bit swap for microcode data reads, not ne=
eded for addresses*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_be64s(&amp;iq_cmd.cmd.u);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0iq_cmd.dptr =3D info-&gt;dptr_baddr;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0iq_cmd.rptr =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0iq_cmd.dptr =3D info-&gt;dptr_baddr | info-&gt;=
gthr_sz &lt;&lt; 60;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0iq_cmd.rptr =3D info-&gt;rptr_baddr | info-&gt;=
sctr_sz &lt;&lt; 60;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 iq_cmd.cptr.u =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 iq_cmd.cptr.s.grp =3D ctrl-&gt;s.grp;<br>
<br>
-- <br>
2.25.1<br>
<br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div><span class=3D"gmail_si=
gnature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><d=
iv dir=3D"ltr">Regards,<div>Kalesh A P</div></div></div></div>

--00000000000038e9b0060c377f60--

--000000000000412dd1060c377f53
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQiwYJKoZIhvcNAQcCoIIQfDCCEHgCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
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
x6xokUN65DN1bn2MkeNs0nQpizDqd0QxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYD
VQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25h
bFNpZ24gMiBDQSAyMDIwAgw3wUUJsDUiPdpordMwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcN
AQkEMSIEIF8QTUOuQEOc5/kHau0cFAH4yYPl9i70csXfLt01Xy6zMBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMTIxMTA4MTIzN1owaQYJKoZIhvcNAQkPMVwwWjAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBt2c1GrWLM
I6K/n+HNTPcaRxSlLRAaa6oYpSHyhzjsW+Of/rLNtM9s4KWKvMLIy3LYAiy+YfbbdhJGML6vXv1D
dAXS6Lmzp2YfLn6ot3UtzxFM099yAtZnmOpuTbx6KURg3uKtfK4ecPer7fsw08AOdX/EJECXXX7f
DTV07DfEm5gb9mBOx4jBW1K/GI+xDkfJPiU36ONq95zW0Ztr/ks0VQR7wQ5bl5OJ1UtEHQCs80dC
N/tuVyJNDvKCRrvzPbu7cRZ3BsW2JNZJxO63jQ86y79sPPJiplxvgC/NM8ZHA/ZhaBt0lYWG8o+5
YwdX41rfZq0NxGZyyFQR9FaDVZrs
--000000000000412dd1060c377f53--
