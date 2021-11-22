Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D5EDC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 11:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239341AbhKVMCl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 07:02:41 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:40458 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhKVMCk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 07:02:40 -0500
Received: by mail-wr1-f44.google.com with SMTP id r8so32142605wra.7
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 03:59:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vrgN9MnjJ7oOBLsvkAJh1j/JC1H7TGyytBcA28Fy8jE=;
        b=n4Z8nHyPKVh6H1ogcpKDqj5t25WTwXh8fMx2+HkHFb+0q7XYX4BmK/R4WFCANOQmTr
         dIuut+vR2Ij0lJmMuXt+dzf6Ufume9Rra7zUVnFQaBgNv0gmNM2J5D358EvZJw7VEp96
         muVnauvuSDqch0S4IDejx8uIiyCL+gd/v2pdJYUHLiCX7p+wPQnXBqhhktD5eCvUnknt
         4uG/Vku+Uv06/7VOShqcpxjACpFgV4+7aIzk75KsIlxU/aBOFgbIELjaqFCC738DZdK5
         QTDcusXbU+DmtuhStELiGF9F4iqdyV5r7zPeN/z/MqB7TUQdZKr0Gw1exoa6xOkZ/63R
         uuIQ==
X-Gm-Message-State: AOAM533+n3dh9jsUg1O7BSaq6QB3mVMRkD+IKzTOKPYxqxZua/meuvJx
        j6Dm930S+snXNSXFJVs4q7aGrhOlGoA=
X-Google-Smtp-Source: ABdhPJwXHavACABjx7ayc+48465bS9rRR2AF/hZPypUThIgONS0oEzAYtzI8JXW1+StP3/ge1C2mTw==
X-Received: by 2002:adf:d1e3:: with SMTP id g3mr38818829wrd.300.1637582373420;
        Mon, 22 Nov 2021 03:59:33 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id d9sm8536969wre.52.2021.11.22.03.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 03:59:33 -0800 (PST)
Subject: Re: [PATCH 10/12] nvmet: Implement basic In-Band Authentication
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org
References: <20211122074727.25988-1-hare@suse.de>
 <20211122074727.25988-11-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <762ce404-9035-30ca-078d-eb0b36223e4c@grimberg.me>
Date:   Mon, 22 Nov 2021 13:59:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211122074727.25988-11-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> +void nvmet_execute_auth_send(struct nvmet_req *req)
> +{
> +	struct nvmet_ctrl *ctrl = req->sq->ctrl;
> +	struct nvmf_auth_dhchap_success2_data *data;
> +	void *d;
> +	u32 tl;
> +	u16 status = 0;
> +
> +	if (req->cmd->auth_send.secp != NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER) {
> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
> +		req->error_loc =
> +			offsetof(struct nvmf_auth_send_command, secp);
> +		goto done;
> +	}
> +	if (req->cmd->auth_send.spsp0 != 0x01) {
> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
> +		req->error_loc =
> +			offsetof(struct nvmf_auth_send_command, spsp0);
> +		goto done;
> +	}
> +	if (req->cmd->auth_send.spsp1 != 0x01) {
> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
> +		req->error_loc =
> +			offsetof(struct nvmf_auth_send_command, spsp1);
> +		goto done;
> +	}
> +	tl = le32_to_cpu(req->cmd->auth_send.tl);
> +	if (!tl) {
> +		status = NVME_SC_INVALID_FIELD | NVME_SC_DNR;
> +		req->error_loc =
> +			offsetof(struct nvmf_auth_send_command, tl);
> +		goto done;
> +	}
> +	if (!nvmet_check_transfer_len(req, tl)) {
> +		pr_debug("%s: transfer length mismatch (%u)\n", __func__, tl);
> +		return;
> +	}
> +
> +	d = kmalloc(tl, GFP_KERNEL);
> +	if (!d) {
> +		status = NVME_SC_INTERNAL;
> +		goto done;
> +	}
> +
> +	status = nvmet_copy_from_sgl(req, 0, d, tl);
> +	if (status) {
> +		kfree(d);
> +		goto done;
> +	}
> +
> +	data = d;
> +	pr_debug("%s: ctrl %d qid %d type %d id %d step %x\n", __func__,
> +		 ctrl->cntlid, req->sq->qid, data->auth_type, data->auth_id,
> +		 req->sq->dhchap_step);
> +	if (data->auth_type != NVME_AUTH_COMMON_MESSAGES &&
> +	    data->auth_type != NVME_AUTH_DHCHAP_MESSAGES)
> +		goto done_failure1;
> +	if (data->auth_type == NVME_AUTH_COMMON_MESSAGES) {
> +		if (data->auth_id == NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE) {
> +			/* Restart negotiation */
> +			pr_debug("%s: ctrl %d qid %d reset negotiation\n", __func__,
> +				 ctrl->cntlid, req->sq->qid);
> +			if (!req->sq->qid) {
> +				status = nvmet_setup_auth(ctrl);

Aren't you leaking memory here?
