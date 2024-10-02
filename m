Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4F21D0945
	for <linux-crypto@vger.kernel.org>; Wed,  2 Oct 2024 14:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727881157; cv=none; b=jDjT83wnGJAge90u0PqILoN5U46HtUOxveCuXAENIL68c3fWRJSFP28JUCzHZrc+pgxSErhXCq326W3c+bbsVbnW4U95f7qnA+A+x5Gh3az4ALQ5npPlEg9wZiNa0xAjOaObb+L7gvsT5rVgLSTjoKv3o7hZKoNHRnmMyuoLJUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727881157; c=relaxed/simple;
	bh=uIsQFxwzHqMEOQICrJ5x6lkTvQ4amtBYJ26dNi9LK0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mus5tXa00L97PH6+UdD5YmAA6k2EN1FBihZymt06DEoudoHgPTVSt+rMd9mKZu5jSSa91+eJ1+GguilOFbpX/FzgEA4GXoAEeGobgMd/EjciF5clXdnUt4SszQXbkHS9ne0ElFaTTxkYT0hYemu8A72m2POKXsyBjceCjYWLHF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ug68Bgkj; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ug68Bgkj"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-539983beb19so3894232e87.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2024 07:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727881153; x=1728485953; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLy+j4O49j2vd2iCrC3P248p7DT9ixUCNBakq+UXtJ8=;
        b=ug68Bgkjj13haD0CTpgYjvYakioqztR6AzpOJM89ckie4J/U+glN2lpuBxWBBIFOdH
         sTt6EFks1CoDWQsjJYu8JJ0/iTUSKdQHnAnflCeWfYsh0imiRReYcpyRp5NJq53lOyhC
         tUSQiDr+r4cMSqCRamHne7Tn3oTNShYLXg/Wbnzz06FoSXffUoz2syLwQPXpR4uxV1UP
         zQcf5e7WAmaDX7O53xf761rj0unilH3S30YvMqnIAZf5nAp1RE/K4kCWyoX+o6MzkeX1
         D1/iQCk/x96qxfW7E+dTde6SIYC2PSBlZDlpNKkeR5M8Udj2YD3OoNTHJbctvcVCAAdi
         E9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727881153; x=1728485953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jLy+j4O49j2vd2iCrC3P248p7DT9ixUCNBakq+UXtJ8=;
        b=adNF3Apo5y1fGncCJ/HlpiK90cd0lhteB1CcldC9P7RHsOILQ3vhvPay19M7eBmJIQ
         k91Br4urwqe6CRPiEJ9lBqp31LUXFu7JlkmbSULlnfXJxJjjxV6iSUV6Wf3xlHIWKYhs
         RXiw9cVgXpz6usZXQfufe0VIbpKCxtfluj+sJzLXxn+8brJNQIHM0vzmx5seKlZTQte8
         kyFyY8+BSRWwtvaDT3WVBq0Z+wFRIQiwG4F3nxRQz/PVlK4WywnKFHQ18Xy6g1rgWura
         /mLzpBCptHmNWnMM4MOyB/EcMFGN9m7AWZ2U5dBV+Lnb4NhwHPVyln2g/GziONBivOdk
         RhyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbp4zQBj60007Yx6MHsq1g/un7F/ftgh9HU1Ip2lnlLEZWqD+9vHn/q1eHriJotZFqfUxeQAn/gN0UiNo=@vger.kernel.org
X-Gm-Message-State: AOJu0YykQ4nJKqwqyIgpsqGblRZsGEQlvjpjT7ctb1LzQqeBnn3dE/N7
	uFTD9a5nr5ozRWao85spNrc3GNEiJEgWU46Zx7wsNFstlYeOWU+Gp5BkAxc7FCHpR7RC2sD7Fgl
	F9KCuo5WcN29yhrBZX/QOdEed49BOQrN0ywqm
X-Google-Smtp-Source: AGHT+IF2A9QKX9WIf2xj8HwlZh/tSamcjdNsyJPojo+MRWwEmnFWlZcSmbzgZuNqArAdhnf2ZBMU1hoY/wehuadqCME=
X-Received: by 2002:a05:6512:1384:b0:535:6a83:86f9 with SMTP id
 2adb3069b0e04-539a07a5b3bmr1825256e87.60.1727881152745; Wed, 02 Oct 2024
 07:59:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1726602374.git.ashish.kalra@amd.com> <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
In-Reply-To: <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Wed, 2 Oct 2024 08:58:56 -0600
Message-ID: <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com, 
	davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2024 at 2:17=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com>=
 wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
>
> Ciphertext hiding separates the ASID space into SNP guest ASIDs and host
> ASIDs. All SNP active guests must have an ASID less than or equal to
> MAX_SNP_ASID provided to the SNP_INIT_EX command. All SEV-legacy guests
> (SEV and SEV-ES) must be greater than MAX_SNP_ASID.
>
> This patch-set adds a new module parameter to the CCP driver defined as
> max_snp_asid which is a user configurable MAX_SNP_ASID to define the
> system-wide maximum SNP ASID value. If this value is not set, then the
> ASID space is equally divided between SEV-SNP and SEV-ES guests.
>
> Ciphertext hiding needs to be enabled on SNP_INIT_EX and therefore this
> new module parameter has to added to the CCP driver.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c       | 26 ++++++++++++++----
>  drivers/crypto/ccp/sev-dev.c | 52 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      | 12 +++++++--
>  3 files changed, 83 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0b851ef937f2..a345b4111ad6 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -171,7 +171,7 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info =
*sev)
>         misc_cg_uncharge(type, sev->misc_cg, 1);
>  }
>
> -static int sev_asid_new(struct kvm_sev_info *sev)
> +static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>  {
>         /*
>          * SEV-enabled guests must use asid from min_sev_asid to max_sev_=
asid.
> @@ -199,6 +199,18 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>
>         mutex_lock(&sev_bitmap_lock);
>
> +       /*
> +        * When CipherTextHiding is enabled, all SNP guests must have an
> +        * ASID less than or equal to MAX_SNP_ASID provided on the
> +        * SNP_INIT_EX command and all the SEV-ES guests must have
> +        * an ASID greater than MAX_SNP_ASID.
> +        */
> +       if (snp_cipher_text_hiding && sev->es_active) {
> +               if (vm_type =3D=3D KVM_X86_SNP_VM)
> +                       max_asid =3D snp_max_snp_asid;
> +               else
> +                       min_asid =3D snp_max_snp_asid + 1;
> +       }
>  again:
>         asid =3D find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_as=
id);
>         if (asid > max_asid) {
> @@ -440,7 +452,7 @@ static int __sev_guest_init(struct kvm *kvm, struct k=
vm_sev_cmd *argp,
>         if (vm_type =3D=3D KVM_X86_SNP_VM)
>                 sev->vmsa_features |=3D SVM_SEV_FEAT_SNP_ACTIVE;
>
> -       ret =3D sev_asid_new(sev);
> +       ret =3D sev_asid_new(sev, vm_type);
>         if (ret)
>                 goto e_no_asid;
>
> @@ -3059,14 +3071,18 @@ void __init sev_hardware_setup(void)
>                                                                        "u=
nusable" :
>                                                                        "d=
isabled",
>                         min_sev_asid, max_sev_asid);
> -       if (boot_cpu_has(X86_FEATURE_SEV_ES))
> +       if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
> +               if (snp_max_snp_asid >=3D (min_sev_asid - 1))
> +                       sev_es_supported =3D false;
>                 pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>                         sev_es_supported ? "enabled" : "disabled",
> -                       min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +                       min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp=
_asid + 1 : 1 :
> +                                                             0, min_sev_=
asid - 1);
> +       }
>         if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>                 pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
>                         sev_snp_supported ? "enabled" : "disabled",
> -                       min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
> +                       min_sev_asid > 1 ? 1 : 0, snp_max_snp_asid ? : mi=
n_sev_asid - 1);
>
>         sev_enabled =3D sev_supported;
>         sev_es_enabled =3D sev_es_supported;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 564daf748293..77900abb1b46 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -73,11 +73,27 @@ static bool psp_init_on_probe =3D true;
>  module_param(psp_init_on_probe, bool, 0444);
>  MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initiali=
zed on module init. Else the PSP will be initialized on the first command r=
equiring it");
>
> +static bool cipher_text_hiding =3D true;
> +module_param(cipher_text_hiding, bool, 0444);
> +MODULE_PARM_DESC(cipher_text_hiding, "  if true, the PSP will enable Cip=
her Text Hiding");
> +
> +static int max_snp_asid;
> +module_param(max_snp_asid, int, 0444);
> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Text =
Hiding");

My read of the spec is if Ciphertext hiding is not enabled there is no
additional split in the ASID space. Am I understanding that correctly?
If so, I don't think we want to enable ciphertext hiding by default
because it might break whatever management of ASIDs systems already
have. For instance right now we have to split SEV-ES and SEV ASIDS,
and SNP guests need SEV-ES ASIDS. This change would half the # of SNP
enable ASIDs on a system.

Also should we move the ASID splitting code to be all in one place?
Right now KVM handles it in sev_hardware_setup().

> +
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
>
> +/* Cipher Text Hiding Enabled */
> +bool snp_cipher_text_hiding;
> +EXPORT_SYMBOL(snp_cipher_text_hiding);
> +
> +/* MAX_SNP_ASID */
> +unsigned int snp_max_snp_asid;
> +EXPORT_SYMBOL(snp_max_snp_asid);
> +
>  static bool psp_dead;
>  static int psp_timeout;
>
> @@ -1064,6 +1080,38 @@ static void snp_set_hsave_pa(void *arg)
>         wrmsrl(MSR_VM_HSAVE_PA, 0);
>  }
>
> +static void sev_snp_enable_ciphertext_hiding(struct sev_data_snp_init_ex=
 *data, int *error)
> +{
> +       struct psp_device *psp =3D psp_master;
> +       struct sev_device *sev;
> +       unsigned int edx;
> +
> +       sev =3D psp->sev_data;
> +
> +       /*
> +        * Check if CipherTextHiding feature is supported and enabled
> +        * in the Platform/BIOS.
> +        */
> +       if ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
> +           sev->snp_plat_status.ciphertext_hiding_cap) {
> +               /* Retrieve SEV CPUID information */
> +               edx =3D cpuid_edx(0x8000001f);
> +               /* Do sanity checks on user-defined MAX_SNP_ASID */
> +               if (max_snp_asid >=3D edx) {
> +                       dev_info(sev->dev, "max_snp_asid module parameter=
 is not valid, limiting to %d\n",
> +                                edx - 1);
> +                       max_snp_asid =3D edx - 1;
> +               }
> +               snp_max_snp_asid =3D max_snp_asid ? : (edx - 1) / 2;
> +
> +               snp_cipher_text_hiding =3D 1;
> +               data->ciphertext_hiding_en =3D 1;
> +               data->max_snp_asid =3D snp_max_snp_asid;
> +
> +               dev_dbg(sev->dev, "SEV-SNP CipherTextHiding feature suppo=
rt enabled\n");
> +       }
> +}
> +
>  static void snp_get_platform_data(void)
>  {
>         struct sev_device *sev =3D psp_master->sev_data;
> @@ -1199,6 +1247,10 @@ static int __sev_snp_init_locked(int *error)
>                 }
>
>                 memset(&data, 0, sizeof(data));
> +
> +               if (cipher_text_hiding)
> +                       sev_snp_enable_ciphertext_hiding(&data, error);
> +
>                 data.init_rmp =3D 1;
>                 data.list_paddr_en =3D 1;
>                 data.list_paddr =3D __psp_pa(snp_range_list);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 6068a89839e1..2102248bd436 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -27,6 +27,9 @@ enum sev_state {
>         SEV_STATE_MAX
>  };
>
> +extern bool snp_cipher_text_hiding;
> +extern unsigned int snp_max_snp_asid;
> +
>  /**
>   * SEV platform and guest management commands
>   */
> @@ -746,10 +749,13 @@ struct sev_data_snp_guest_request {
>  struct sev_data_snp_init_ex {
>         u32 init_rmp:1;
>         u32 list_paddr_en:1;
> -       u32 rsvd:30;
> +       u32 rapl_dis:1;
> +       u32 ciphertext_hiding_en:1;
> +       u32 rsvd:28;
>         u32 rsvd1;
>         u64 list_paddr;
> -       u8  rsvd2[48];
> +       u16 max_snp_asid;
> +       u8  rsvd2[46];
>  } __packed;
>
>  /**
> @@ -841,6 +847,8 @@ struct snp_feature_info {
>         u32 edx;
>  } __packed;
>
> +#define SNP_CIPHER_TEXT_HIDING_SUPPORTED       BIT(3)
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>
>  /**
> --
> 2.34.1
>
>
