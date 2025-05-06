Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58945281371
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 14:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746540801; cv=none; b=lzqD10kuR0sY7GqDYrk6JpxeJ1U9KM4ef4QeYn8CJTYD5T3cejM1kOn1C8cNtw9bUIiN1hNtrROEH7KORbPzp/xaRaYCuvUZz2DBY2+0YFtijEq3YVpjnPuGMLFdaampUjNlgzALYplzqijKWbs0oEABePRvDLkt+JtkDuhN1Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746540801; c=relaxed/simple;
	bh=dvnpBTc5+V4/wKRdMg2GHV3TaYrI7wpbz7l2TiXkoro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJim1B6XIqMKHlDr7tbJhRiHgt4J1xuThdlAZrkhodl1xTj3FlxoTobTYwchK0EnXuZ9Tv4Ft5zHljFUc1btbm9LmbX3PEshDwqAagfGbE23ZdUVCaBi/KfloxiEGuo77Bd3MufVrYguseGt36DeP3llxq342A7nalrmWVhGU3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TH3IqP4I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TH3IqP4I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746540798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UFcgBeXDokvr+kUt+Nx4wd/ULZnjMDwH1N2JLsWAOOw=;
	b=TH3IqP4ICmBfw1d5MZEnJ+Y/9KPKZkdvYPS9Gsf4fe0trTZzi5j7LlykSIXGRWkXvULjcv
	kZbwCbgZP854QYpV/yEQjP2UXXyVUA+/TGuCKY34pcZrRXvhefzqiPjHDxAkLDzVJswVD3
	po/zvhuI/Oodnr3gGiFUoo+HA4LotI0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-t4037p3wN5K3lXpyMbW7CQ-1; Tue, 06 May 2025 10:13:14 -0400
X-MC-Unique: t4037p3wN5K3lXpyMbW7CQ-1
X-Mimecast-MFC-AGG-ID: t4037p3wN5K3lXpyMbW7CQ_1746540793
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ac6ef2d1b7dso539338466b.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 May 2025 07:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746540793; x=1747145593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UFcgBeXDokvr+kUt+Nx4wd/ULZnjMDwH1N2JLsWAOOw=;
        b=vZYLAMTfLgj/sWc25y3nwEG/pRi6ifoSOJOYCjTmdd8SfKHyHc6ngpuXHYATWrr4dG
         vNWnhkvTVmRzbpB5Vy+wEJBZUpZKbJWq5DRrFtqhDRtmXUbeWzI2no9gCMR0uc1BY4Eg
         CZtFo2qpitL6OAjh0kPgDw7s9WfXCczO2BGG7tsh1L3yvhOHcxMoOUGfTmDx66teNLU5
         GBcQ7Ttye9m9N69HkEmOQTu0wl2+VKeChzNdiDmWcwgQa7WZ3jYpzC//EiOlQtc35W6O
         txSwy/LySIu7W8H+0zunjpSbUwfFzWm51pyXWSa+XSoh5Y9xz2UHLHBMnSyjYFEqTtdN
         1t+A==
X-Forwarded-Encrypted: i=1; AJvYcCXBYQzcpCuwort9lhaFYzLg3bVgJvzF24H5zLgj1oTQei2XOFZntEOc1OlL7lUw4/l7ixhSLszPShL+dH8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5pRgXFmVtgop6Qyp0bt2akpR//WdOy6dePeAJN1CEnRzssqxo
	NqnYD17j4jH6XEzU/m/T9XlqezhwnCZGuvgHDf9LVQXncYYUmRxeyJpEf1/NCFlEQeG0+Sx5rhJ
	T/GmziPF4tL3PL01/RoGP56ajAT5q8h2eWs3do7oK+j1KBnR+ldwRrX5ByVNi2w==
X-Gm-Gg: ASbGncuFR/9ugJ//YFKL0dDIpMocYWYlKXtVVRJlGTy6KALuDoSc9hRDRmo+Qzrql42
	TlehZut9W3y8gw7CsMI86eQCea1YTlMH1c+sv5tltTg3I1XR1Gk4FkmaogZaFEeo03iAYMr2CQ/
	tMI4hndnUioN89HmDhETr43etDjEWNKJl2tCCUVXWFNZ+TdHzrp2rdwXVs4UzDmIPm+IrFDjIuW
	eTuKs/P+T2uf2NuhvgohR7SyheMtZSPxVknuRamcy61NXKSm/3eaU1RdoAqPbM++Q3dsdnPODJI
	BpvPYpB8Dmj3muYD
X-Received: by 2002:a17:907:a08e:b0:ace:9d4e:d0cd with SMTP id a640c23a62f3a-ad1a48bd2c0mr1016932266b.7.1746540793549;
        Tue, 06 May 2025 07:13:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBtjlS6sVWj/jhXomSr6feRAM5taE6rOBhOmzWM1geyTp2Xsw9XEuNk4QndQH7TAg8XB5sEA==
X-Received: by 2002:a17:907:a08e:b0:ace:9d4e:d0cd with SMTP id a640c23a62f3a-ad1a48bd2c0mr1016929066b.7.1746540793005;
        Tue, 06 May 2025 07:13:13 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.145.28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad18914d031sm710777166b.20.2025.05.06.07.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 07:13:12 -0700 (PDT)
Date: Tue, 6 May 2025 16:13:04 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Qunqin Zhao <zhaoqunqin@loongson.cn>
Cc: lee@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	peterhuewe@gmx.de, jarkko@kernel.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-crypto@vger.kernel.org, jgg@ziepe.ca, 
	linux-integrity@vger.kernel.org, pmenzel@molgen.mpg.de, Yinggang Gu <guyinggang@loongson.cn>, 
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH v9 4/5] tpm: Add a driver for Loongson TPM device
Message-ID: <2nuadbg5awe6gvagxg7t5ewvxsbmiq4qrcrycvnrmt2etzq2ke@6oyzavctwrma>
References: <20250506031947.11130-1-zhaoqunqin@loongson.cn>
 <20250506031947.11130-5-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250506031947.11130-5-zhaoqunqin@loongson.cn>

On Tue, May 06, 2025 at 11:19:46AM +0800, Qunqin Zhao wrote:
>Loongson Security Engine supports random number generation, hash,
>symmetric encryption and asymmetric encryption. Based on these
>encryption functions, TPM2 have been implemented in the Loongson
>Security Engine firmware. This driver is responsible for copying data
>into the memory visible to the firmware and receiving data from the
>firmware.
>
>Co-developed-by: Yinggang Gu <guyinggang@loongson.cn>
>Signed-off-by: Yinggang Gu <guyinggang@loongson.cn>
>Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
>Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
>Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
>---
>v9: "tpm_loongson_driver" --> "tpm_loongson"
>    "depends on CRYPTO_DEV_LOONGSON_SE" --> "depends on MFD_LOONGSON_SE"
>
>v8: In the send callback, it will wait until the TPM2 command is
>    completed. So do not need to wait in the recv callback.
>    Removed Jarkko's tag cause there are some changes in v8
>
>v7: Moved Kconfig entry between TCG_IBMVTPM and TCG_XEN.
>    Added Jarkko's tag(a little change, should be fine).
>
>v6: Replace all "ls6000se" with "loongson"
>    Prefix all with tpm_loongson instead of tpm_lsse.
>    Removed Jarkko's tag cause there are some changes in v6
>
>v5: None
>v4: Prefix all with tpm_lsse instead of tpm.
>    Removed MODULE_AUTHOR fields.
>
>v3: Added reminder about Loongson security engine to git log.
>
> drivers/char/tpm/Kconfig        |  9 ++++
> drivers/char/tpm/Makefile       |  1 +
> drivers/char/tpm/tpm_loongson.c | 78 +++++++++++++++++++++++++++++++++
> 3 files changed, 88 insertions(+)
> create mode 100644 drivers/char/tpm/tpm_loongson.c
>
>diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
>index fe4f3a609..13f0682c6 100644
>--- a/drivers/char/tpm/Kconfig
>+++ b/drivers/char/tpm/Kconfig
>@@ -189,6 +189,15 @@ config TCG_IBMVTPM
> 	  will be accessible from within Linux.  To compile this driver
> 	  as a module, choose M here; the module will be called tpm_ibmvtpm.
>
>+config TCG_LOONGSON
>+	tristate "Loongson TPM Interface"
>+	depends on MFD_LOONGSON_SE
>+	help
>+	  If you want to make Loongson TPM support available, say Yes and
>+	  it will be accessible from within Linux. To compile this
>+	  driver as a module, choose M here; the module will be called
>+	  tpm_loongson.
>+
> config TCG_XEN
> 	tristate "XEN TPM Interface"
> 	depends on TCG_TPM && XEN
>diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
>index 2b004df8c..cb534b235 100644
>--- a/drivers/char/tpm/Makefile
>+++ b/drivers/char/tpm/Makefile
>@@ -45,3 +45,4 @@ obj-$(CONFIG_TCG_CRB) += tpm_crb.o
> obj-$(CONFIG_TCG_ARM_CRB_FFA) += tpm_crb_ffa.o
> obj-$(CONFIG_TCG_VTPM_PROXY) += tpm_vtpm_proxy.o
> obj-$(CONFIG_TCG_FTPM_TEE) += tpm_ftpm_tee.o
>+obj-$(CONFIG_TCG_LOONGSON) += tpm_loongson.o
>diff --git a/drivers/char/tpm/tpm_loongson.c b/drivers/char/tpm/tpm_loongson.c
>new file mode 100644
>index 000000000..cbbd9c22a
>--- /dev/null
>+++ b/drivers/char/tpm/tpm_loongson.c
>@@ -0,0 +1,78 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/* Copyright (c) 2025 Loongson Technology Corporation Limited. */
>+
>+#include <linux/device.h>
>+#include <linux/mfd/loongson-se.h>
>+#include <linux/platform_device.h>
>+#include <linux/wait.h>
>+
>+#include "tpm.h"
>+
>+struct tpm_loongson_cmd {
>+	u32 cmd_id;
>+	u32 data_off;
>+	u32 data_len;
>+	u32 pad[5];
>+};
>+
>+static int tpm_loongson_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>+{
>+	struct loongson_se_engine *tpm_engine = dev_get_drvdata(&chip->dev);
>+	struct tpm_loongson_cmd *cmd_ret = tpm_engine->command_ret;
>+
>+	memcpy(buf, tpm_engine->data_buffer, cmd_ret->data_len);

Should we limit the memcpy to `count`?

I mean, can happen that `count` is less than `cmd_ret->data_len`?

Thanks,
Stefano

>+
>+	return cmd_ret->data_len;
>+}
>+
>+static int tpm_loongson_send(struct tpm_chip *chip, u8 *buf, size_t count)
>+{
>+	struct loongson_se_engine *tpm_engine = dev_get_drvdata(&chip->dev);
>+	struct tpm_loongson_cmd *cmd = tpm_engine->command;
>+
>+	cmd->data_len = count;
>+	memcpy(tpm_engine->data_buffer, buf, count);
>+
>+	return loongson_se_send_engine_cmd(tpm_engine);
>+}
>+
>+static const struct tpm_class_ops tpm_loongson_ops = {
>+	.flags = TPM_OPS_AUTO_STARTUP,
>+	.recv = tpm_loongson_recv,
>+	.send = tpm_loongson_send,
>+};
>+
>+static int tpm_loongson_probe(struct platform_device *pdev)
>+{
>+	struct loongson_se_engine *tpm_engine;
>+	struct device *dev = &pdev->dev;
>+	struct tpm_loongson_cmd *cmd;
>+	struct tpm_chip *chip;
>+
>+	tpm_engine = loongson_se_init_engine(dev->parent, SE_ENGINE_TPM);
>+	if (!tpm_engine)
>+		return -ENODEV;
>+	cmd = tpm_engine->command;
>+	cmd->cmd_id = SE_CMD_TPM;
>+	cmd->data_off = tpm_engine->buffer_off;
>+
>+	chip = tpmm_chip_alloc(dev, &tpm_loongson_ops);
>+	if (IS_ERR(chip))
>+		return PTR_ERR(chip);
>+	chip->flags = TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_IRQ;
>+	dev_set_drvdata(&chip->dev, tpm_engine);
>+
>+	return tpm_chip_register(chip);
>+}
>+
>+static struct platform_driver tpm_loongson = {
>+	.probe   = tpm_loongson_probe,
>+	.driver  = {
>+		.name  = "loongson-tpm",
>+	},
>+};
>+module_platform_driver(tpm_loongson);
>+
>+MODULE_ALIAS("platform:loongson-tpm");
>+MODULE_LICENSE("GPL");
>+MODULE_DESCRIPTION("Loongson TPM driver");
>-- 
>2.45.2
>
>

