Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B05EE7849A
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Oct 2023 09:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbjJBJQP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Oct 2023 05:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbjJBJQO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Oct 2023 05:16:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69A39E
        for <linux-crypto@vger.kernel.org>; Mon,  2 Oct 2023 02:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696238126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XeICUbMfmTh7beF2Sq022ow9UPF6kDmSYo3jFc/ZOTU=;
        b=ZfCcEE3WGuvYx9h/2Q/9R/QZXUvd32zB7LGRew/bsRfquNwjhSGXESKAK4zsT5vVJ0Keot
        rYaM/hAq/0seDmCLlTcDb2Vlt0ATZNCV40M8oOJhHqcjdwsSWxbqtb4t3OTavGe2KXlQEC
        sCksEwvv55zm/aiiAQmczotZ38pIzk4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-R-LOw29FM_GH4bd9fkwt_Q-1; Mon, 02 Oct 2023 05:15:05 -0400
X-MC-Unique: R-LOw29FM_GH4bd9fkwt_Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EEAE1C09A46;
        Mon,  2 Oct 2023 09:15:05 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2949F40107B;
        Mon,  2 Oct 2023 09:15:05 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
        id 1E38130C0500; Mon,  2 Oct 2023 09:15:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 1D4CC3FD54;
        Mon,  2 Oct 2023 11:15:05 +0200 (CEST)
Date:   Mon, 2 Oct 2023 11:15:05 +0200 (CEST)
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Hrivnak <mhrivnak@redhat.com>,
        Eric Garver <egarver@redhat.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH v2] qat: fix deadlock in backlog processing
In-Reply-To: <ZRc75XGd92MgaVko@gcabiddu-mobl1.ger.corp.intel.com>
Message-ID: <6b5cb6f-e4bb-8328-a718-f21b2575b8@redhat.com>
References: <af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com> <ZQ2vJNs/7ZzY44z1@gcabiddu-mobl1.ger.corp.intel.com> <ed935382-98ee-6f5d-2f-7c6badfd3abb@redhat.com> <ZRc75XGd92MgaVko@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Fri, 29 Sep 2023, Giovanni Cabiddu wrote:

> On Fri, Sep 22, 2023 at 06:34:16PM +0200, Mikulas Patocka wrote:
> >
> > > Also, deserves a fixes tag.
> > 
> > "Fixes" tag is for something that worked and that was broken in some 
> > previous commit.
> That's right.
> 
> > A quick search through git shows that QAT backlogging was 
> > broken since the introduction of QAT.
> The driver was moved from drivers/crypto/qat to drivers/crypto/intel/qat
> that's why you see a single patch.
> This fixes 386823839732 ("crypto: qat - add backlog mechanism")

But before 386823839732 it also didn't work - it returned -EBUSY without 
queuing the request and deadlocked.

> Thanks - when I proposed the rework I was thinking at a solution without
> gotos. Here is a draft:

Yes - it is possible to fix it this way.



> ------------8<----------------
>  .../intel/qat/qat_common/qat_algs_send.c      | 40 ++++++++++---------
>  1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs_send.c b/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> index bb80455b3e81..18c6a233ab96 100644
> --- a/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> +++ b/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> @@ -40,17 +40,7 @@ void qat_alg_send_backlog(struct qat_instance_backlog *backlog)
>  	spin_unlock_bh(&backlog->lock);
>  }
>  
> -static void qat_alg_backlog_req(struct qat_alg_req *req,
> -				struct qat_instance_backlog *backlog)
> -{
> -	INIT_LIST_HEAD(&req->list);
> -
> -	spin_lock_bh(&backlog->lock);
> -	list_add_tail(&req->list, &backlog->list);
> -	spin_unlock_bh(&backlog->lock);
> -}
> -
> -static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
> +static bool qat_alg_try_enqueue(struct qat_alg_req *req)
>  {
>  	struct qat_instance_backlog *backlog = req->backlog;
>  	struct adf_etr_ring_data *tx_ring = req->tx_ring;
> @@ -58,22 +48,36 @@ static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
>  
>  	/* If any request is already backlogged, then add to backlog list */
>  	if (!list_empty(&backlog->list))
> -		goto enqueue;
> +		return false;
>  
>  	/* If ring is nearly full, then add to backlog list */
>  	if (adf_ring_nearly_full(tx_ring))
> -		goto enqueue;
> +		return false;
>  
>  	/* If adding request to HW ring fails, then add to backlog list */
>  	if (adf_send_message(tx_ring, fw_req))
> -		goto enqueue;
> +		return false;
>  
> -	return -EINPROGRESS;
> +	return true;
> +}
>  
> -enqueue:
> -	qat_alg_backlog_req(req, backlog);
>  
> -	return -EBUSY;
> +static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
> +{
> +	struct qat_instance_backlog *backlog = req->backlog;
> +	int ret = -EINPROGRESS;
> +
> +	if (qat_alg_try_enqueue(req))
> +		return ret;
> +
> +	spin_lock_bh(&backlog->lock);
> +	if (!qat_alg_try_enqueue(req)) {
> +		list_add_tail(&req->list, &backlog->list);
> +		ret = -EBUSY;
> +	}
> +	spin_unlock_bh(&backlog->lock);
> +
> +	return ret;
>  }
>  
>  int qat_alg_send_message(struct qat_alg_req *req)
> -- 
> 2.41.0


Reviwed-by: Mikulas Patocka <mpatocka@redhat.com>

Mikulas


