Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D96DC4346E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 05:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0760206C1
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 05:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgIXFAy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 01:00:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:5968 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgIXFAy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 01:00:54 -0400
IronPort-SDR: OfpLZDhRmvDs2nqyvxAllb63aV3m5+pe16cae/6sYVH12ZxMS3K4wOkePVrEMKysSvllIrHKv7
 ddD2CZQzjO1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148751722"
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="148751722"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 22:00:52 -0700
IronPort-SDR: sFUnctqmR4qg1KgsfRgpOyMaAKHwkJVp2+Ol5m45qzFnvoQ+jf1n3W3d5DD2GcWB1QDi3Mk2fZ
 x+Xd49rWtnNA==
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="455195672"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 22:00:50 -0700
Date:   Thu, 24 Sep 2020 06:00:42 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        qat-linux <qat-linux@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: qat - convert to use DEFINE_SEQ_ATTRIBUTE
 macro
Message-ID: <20200924050042.GA32206@silpixa00400314>
References: <7a1e8142cb4944ee95cea13e7efad23d@irsmsx602.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a1e8142cb4944ee95cea13e7efad23d@irsmsx602.ger.corp.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 16, 2020 at 03:50:17AM +0100, Liu Shixin wrote:
> Use DEFINE_SEQ_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>

Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

> ---
>  drivers/crypto/qat/qat_common/adf_cfg.c       | 19 +--------
>  .../qat/qat_common/adf_transport_debug.c      | 42 ++-----------------
>  2 files changed, 5 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
> index ac462796cefc..22ae32838113 100644
> --- a/drivers/crypto/qat/qat_common/adf_cfg.c
> +++ b/drivers/crypto/qat/qat_common/adf_cfg.c
> @@ -52,24 +52,7 @@ static const struct seq_operations qat_dev_cfg_sops = {
>  	.show = qat_dev_cfg_show
>  };
>  
> -static int qat_dev_cfg_open(struct inode *inode, struct file *file)
> -{
> -	int ret = seq_open(file, &qat_dev_cfg_sops);
> -
> -	if (!ret) {
> -		struct seq_file *seq_f = file->private_data;
> -
> -		seq_f->private = inode->i_private;
> -	}
> -	return ret;
> -}
> -
> -static const struct file_operations qat_dev_cfg_fops = {
> -	.open = qat_dev_cfg_open,
> -	.read = seq_read,
> -	.llseek = seq_lseek,
> -	.release = seq_release
> -};
> +DEFINE_SEQ_ATTRIBUTE(qat_dev_cfg);
>  
>  /**
>   * adf_cfg_dev_add() - Create an acceleration device configuration table.
> diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
> index 2a2eccbf56ec..dac25ba47260 100644
> --- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
> +++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
> @@ -77,31 +77,14 @@ static void adf_ring_stop(struct seq_file *sfile, void *v)
>  	mutex_unlock(&ring_read_lock);
>  }
>  
> -static const struct seq_operations adf_ring_sops = {
> +static const struct seq_operations adf_ring_debug_sops = {
>  	.start = adf_ring_start,
>  	.next = adf_ring_next,
>  	.stop = adf_ring_stop,
>  	.show = adf_ring_show
>  };
>  
> -static int adf_ring_open(struct inode *inode, struct file *file)
> -{
> -	int ret = seq_open(file, &adf_ring_sops);
> -
> -	if (!ret) {
> -		struct seq_file *seq_f = file->private_data;
> -
> -		seq_f->private = inode->i_private;
> -	}
> -	return ret;
> -}
> -
> -static const struct file_operations adf_ring_debug_fops = {
> -	.open = adf_ring_open,
> -	.read = seq_read,
> -	.llseek = seq_lseek,
> -	.release = seq_release
> -};
> +DEFINE_SEQ_ATTRIBUTE(adf_ring_debug);
>  
>  int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
>  {
> @@ -188,31 +171,14 @@ static void adf_bank_stop(struct seq_file *sfile, void *v)
>  	mutex_unlock(&bank_read_lock);
>  }
>  
> -static const struct seq_operations adf_bank_sops = {
> +static const struct seq_operations adf_bank_debug_sops = {
>  	.start = adf_bank_start,
>  	.next = adf_bank_next,
>  	.stop = adf_bank_stop,
>  	.show = adf_bank_show
>  };
>  
> -static int adf_bank_open(struct inode *inode, struct file *file)
> -{
> -	int ret = seq_open(file, &adf_bank_sops);
> -
> -	if (!ret) {
> -		struct seq_file *seq_f = file->private_data;
> -
> -		seq_f->private = inode->i_private;
> -	}
> -	return ret;
> -}
> -
> -static const struct file_operations adf_bank_debug_fops = {
> -	.open = adf_bank_open,
> -	.read = seq_read,
> -	.llseek = seq_lseek,
> -	.release = seq_release
> -};
> +DEFINE_SEQ_ATTRIBUTE(adf_bank_debug);
>  
>  int adf_bank_debugfs_add(struct adf_etr_bank_data *bank)
>  {
> -- 
> 2.25.1
> 
