Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95544C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 12:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C3EA206DF
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 12:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ebgzqgad"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfLCMB6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 07:01:58 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45283 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfLCMB6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 07:01:58 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so3274153wrj.12
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2019 04:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=29UOTYK8SpJyaDM9ZoxMVsHUVz+atW0TxXJjZ/TkdbI=;
        b=ebgzqgadg3xvHI7DCNeSRb3SqmUS4JEkzlmcEZ+949nh6coZT8YmoADPVZIMi3cH3V
         QpZN5g+kqBar92tDwfiNMVKqYlFuv7QFPCAkUFNovQO3NuhWK4TdxRUNxUqPuBntPvPO
         cmqaSpUCqoFEvme4J1wVAC6luBdHbjIrc24gKsBxM2OFNw2Pw1cIdTm8D9jKfpp2TWZT
         eTRgXfQQq0ZrGKD5Mlcb9niZKpzoCTRXSWzROU2YSKIGQJEPmRST+vYwcv1KfgKLv3VQ
         H8LH0gEn7iSJBXuRb/KdQSKlunpRywEJbPuX/Wikljnd0ID+UcmycZugZXc+VePvnFbi
         yUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=29UOTYK8SpJyaDM9ZoxMVsHUVz+atW0TxXJjZ/TkdbI=;
        b=AEcQFUWxkEokq+uZtU6JaDSdWRN1hFl/fQTOgu4mKxVWlVrhDJCtouVKbZ6WiwOAuz
         LUJXpgEzjTr+Yb7ULmeypoy9EYt6hKkGwjyGKFA6plMJMHuFQ+90er0DVK53VAAqSxkS
         1QTgzMx85hOuD8h7IzxWbzi2K1Xi9KXvgh1PD66126Yrg+1vbVmonnOGc4n7YT6Cysf+
         A3k07wNIfRECiyXwUq/wvyg8vxbGh5Z7e2u4FRFkBTKs+voEM8IxId95rqctpeTjfZXB
         erTw2xYryoq3yknN5a7c36oIOn4vkt17e78Sxnd14Zvlr9gejNG/3La6oJURaDiYCtze
         p5Jw==
X-Gm-Message-State: APjAAAW+S0Prw19KLgNMzJ2CWyY1XASRJV9WDnuPch7RqRJ7K5PlJvN9
        ofpZG5KPodnW1QFeZTcmovY23w==
X-Google-Smtp-Source: APXvYqzeCYfKU4d7ZRfTfFmN8Ix7i4wx0V0fzwM9qJsK0qdGQgsdDooLD+03lUpGQsSg4liIOwjTtQ==
X-Received: by 2002:adf:f052:: with SMTP id t18mr4645223wro.192.1575374514678;
        Tue, 03 Dec 2019 04:01:54 -0800 (PST)
Received: from google.com ([100.105.32.75])
        by smtp.gmail.com with ESMTPSA id e6sm2628450wru.44.2019.12.03.04.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 04:01:53 -0800 (PST)
Date:   Tue, 3 Dec 2019 13:01:48 +0100
From:   Marco Elver <elver@google.com>
To:     Zaibo Xu <xuzaibo@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com, linuxarm@huawei.com, fanghao11@huawei.com,
        yekai13@huawei.com, zhangwei375@huawei.com,
        forest.zhouchang@huawei.com
Subject: Re: [PATCH v3 1/5] crypto: hisilicon - add HiSilicon SEC V2 driver
Message-ID: <20191203120148.GA68157@google.com>
References: <1573643468-1812-1-git-send-email-xuzaibo@huawei.com>
 <1573643468-1812-2-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573643468-1812-2-git-send-email-xuzaibo@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Avoid using __sync builtins and instead prefer the kernel's own
facilities:

See comments below for suggestions, preserving the assumed memory
ordering requirements (but please double-check). By using atomic_t
instead of __sync, you'd also avoid any data races due to plain
concurrent accesses.

Reported in: https://lore.kernel.org/linux-crypto/CANpmjNM2b26Oo6k-4EqfrJf1sBj3WoFf-NQnwsLr3EW9B=G8kw@mail.gmail.com/

On Wed, 13 Nov 2019, Zaibo Xu wrote:

> SEC driver provides PCIe hardware device initiation with
> AES, SM4, and 3DES skcipher algorithms registered to Crypto.
> It uses Hisilicon QM as interface to CPU.
> 
> Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/crypto/hisilicon/Kconfig           |  16 +
>  drivers/crypto/hisilicon/Makefile          |   1 +
>  drivers/crypto/hisilicon/sec2/Makefile     |   2 +
>  drivers/crypto/hisilicon/sec2/sec.h        | 132 +++++
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 886 +++++++++++++++++++++++++++++
>  drivers/crypto/hisilicon/sec2/sec_crypto.h | 198 +++++++
>  drivers/crypto/hisilicon/sec2/sec_main.c   | 640 +++++++++++++++++++++
>  7 files changed, 1875 insertions(+)
>  create mode 100644 drivers/crypto/hisilicon/sec2/Makefile
>  create mode 100644 drivers/crypto/hisilicon/sec2/sec.h
>  create mode 100644 drivers/crypto/hisilicon/sec2/sec_crypto.c
>  create mode 100644 drivers/crypto/hisilicon/sec2/sec_crypto.h
>  create mode 100644 drivers/crypto/hisilicon/sec2/sec_main.c
[...]
> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
> new file mode 100644
> index 0000000..443b6c5
> --- /dev/null
> +++ b/drivers/crypto/hisilicon/sec2/sec.h
> @@ -0,0 +1,132 @@
[...]
> +
> +/* SEC request of Crypto */
> +struct sec_req {
> +	struct sec_sqe sec_sqe;
> +	struct sec_ctx *ctx;
> +	struct sec_qp_ctx *qp_ctx;
> +
> +	/* Cipher supported only at present */
> +	struct sec_cipher_req c_req;
> +	int err_type;
> +	int req_id;
> +
> +	/* Status of the SEC request */
> +	int fake_busy;

This could be

	atomic_t fake_busy;

> +};
> +
[...]
> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> new file mode 100644
> index 0000000..23092a9
> --- /dev/null
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> @@ -0,0 +1,886 @@

Add

	#include <linux/atomic.h>

[...]
> +static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
> +{
> +	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
> +	int ret;
> +
> +	mutex_lock(&qp_ctx->req_lock);
> +	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
> +	mutex_unlock(&qp_ctx->req_lock);
> +
> +	if (ret == -EBUSY)
> +		return -ENOBUFS;
> +
> +	if (!ret) {
> +		if (req->fake_busy)

This could be:

	atomic_read(&req->fake_busy)

> +			ret = -EBUSY;
> +		else
> +			ret = -EINPROGRESS;
> +	}
> +
> +	return ret;
> +}
[...]
> +static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req)
> +{
> +	struct skcipher_request *sk_req = req->c_req.sk_req;
> +	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
> +
> +	atomic_dec(&qp_ctx->pending_reqs);
> +	sec_free_req_id(req);
> +
> +	/* IV output at encrypto of CBC mode */
> +	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && req->c_req.encrypt)
> +		sec_update_iv(req);
> +
> +	if (__sync_bool_compare_and_swap(&req->fake_busy, 1, 0))

This could be:

	int expect_val = 1;
	...
	if (atomic_try_cmpxchg_relaxed(&req->fake_busy, &expect_val, 0))

> +		sk_req->base.complete(&sk_req->base, -EINPROGRESS);
> +
> +	sk_req->base.complete(&sk_req->base, req->err_type);
> +}
> +
> +static void sec_request_uninit(struct sec_ctx *ctx, struct sec_req *req)
> +{
> +	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
> +
> +	atomic_dec(&qp_ctx->pending_reqs);
> +	sec_free_req_id(req);
> +	sec_put_queue_id(ctx, req);
> +}
> +
> +static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
> +{
> +	struct sec_qp_ctx *qp_ctx;
> +	int issue_id, ret;
> +
> +	/* To load balance */
> +	issue_id = sec_get_queue_id(ctx, req);
> +	qp_ctx = &ctx->qp_ctx[issue_id];
> +
> +	req->req_id = sec_alloc_req_id(req, qp_ctx);
> +	if (req->req_id < 0) {
> +		sec_put_queue_id(ctx, req);
> +		return req->req_id;
> +	}
> +
> +	if (ctx->fake_req_limit <= atomic_inc_return(&qp_ctx->pending_reqs))
> +		req->fake_busy = 1;
> +	else
> +		req->fake_busy = 0;

These could be:

	atomic_set(&req->fake_busy, ...)

> +
> +	ret = ctx->req_op->get_res(ctx, req);
> +	if (ret) {
> +		atomic_dec(&qp_ctx->pending_reqs);
> +		sec_request_uninit(ctx, req);
> +		dev_err(SEC_CTX_DEV(ctx), "get resources failed!\n");
> +	}
> +
> +	return ret;
> +}

Thanks,
-- Marco
