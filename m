Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F105C636CA
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 06:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEEF960E0B
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 06:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhGQGdL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 02:33:11 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:37717 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhGQGdJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 02:33:09 -0400
Received: by mail-pf1-f182.google.com with SMTP id 17so10728156pfz.4
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jul 2021 23:30:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=46YAVZOxsHQqCZvVDcQ2D8oRGYmfN9hSScqkRnqRnqA=;
        b=Fpj4VQQnluecsAzSjSBAM9WAgY58jg3HOqpDYQ0gFVoJtQXhAk6sNijlSIsJlKnpqZ
         7gU1/UXt/7/Lf0TTfq5HfAOBWlZ608+gSHWxYywuzVTMTsgtVWYp0MLWmIKpWl0cWpTo
         QVEC3UUgsQsTt4hsbvlFrP+13p4vJM9ej6GCktIEGAnz5IIFJUXmhcDWZVb6bzJhmCUU
         glqG2a2LOekMy2wnsKefVBs2IAazBasWNjEyYiwXf/IhNcrGx6gchYCdgRmoKMHypUfD
         AJ5Bm698iGVrSyPOi2OMouLBo2Rmyd2r2XgpFbVU+Sar05Y44DdyWsZh46fgdB8WyYmj
         qtYw==
X-Gm-Message-State: AOAM533wzhRueweVh1T+09Qr4ytNMWw3em8H9ljFT4+oYX+IlEO7wMf7
        S7XxtmU1yEJhc5ejTNCP86w55Q2MrT4=
X-Google-Smtp-Source: ABdhPJyJTj5X7ORHeogJQdNIPFfT143p4okpjNN+COImvJwwyQmgK3Ma2alPCBL4Q+SinYH4vJzZog==
X-Received: by 2002:a65:40c3:: with SMTP id u3mr13810419pgp.401.1626503412237;
        Fri, 16 Jul 2021 23:30:12 -0700 (PDT)
Received: from [10.0.0.146] ([162.211.128.122])
        by smtp.gmail.com with ESMTPSA id j12sm11721649pfj.208.2021.07.16.23.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 23:30:11 -0700 (PDT)
Subject: Re: [PATCH 05/11] nvme: add definitions for NVMe In-Band
 authentication
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <keith.busch@wdc.com>, linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-6-hare@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <affd7d4a-6eb5-20b4-fcb3-7e8a0767d7a2@grimberg.me>
Date:   Fri, 16 Jul 2021 23:30:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716110428.9727-6-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 7/16/21 4:04 AM, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   include/linux/nvme.h | 185 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 184 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/nvme.h b/include/linux/nvme.h
> index b7c4c4130b65..7b94abacfd08 100644
> --- a/include/linux/nvme.h
> +++ b/include/linux/nvme.h
> @@ -19,6 +19,7 @@
>   #define NVMF_TRSVCID_SIZE	32
>   #define NVMF_TRADDR_SIZE	256
>   #define NVMF_TSAS_SIZE		256
> +#define NVMF_AUTH_HASH_LEN	64
>   
>   #define NVME_DISC_SUBSYS_NAME	"nqn.2014-08.org.nvmexpress.discovery"
>   
> @@ -1263,6 +1264,8 @@ enum nvmf_capsule_command {
>   	nvme_fabrics_type_property_set	= 0x00,
>   	nvme_fabrics_type_connect	= 0x01,
>   	nvme_fabrics_type_property_get	= 0x04,
> +	nvme_fabrics_type_auth_send	= 0x05,
> +	nvme_fabrics_type_auth_receive	= 0x06,
>   };
>   
>   #define nvme_fabrics_type_name(type)   { type, #type }
> @@ -1270,7 +1273,9 @@ enum nvmf_capsule_command {
>   	__print_symbolic(type,						\
>   		nvme_fabrics_type_name(nvme_fabrics_type_property_set),	\
>   		nvme_fabrics_type_name(nvme_fabrics_type_connect),	\
> -		nvme_fabrics_type_name(nvme_fabrics_type_property_get))
> +		nvme_fabrics_type_name(nvme_fabrics_type_property_get), \
> +		nvme_fabrics_type_name(nvme_fabrics_type_auth_send),	\
> +		nvme_fabrics_type_name(nvme_fabrics_type_auth_receive))
>   
>   /*
>    * If not fabrics command, fctype will be ignored.
> @@ -1393,6 +1398,182 @@ struct nvmf_property_get_command {
>   	__u8		resv4[16];
>   };
>   
> +struct nvmf_auth_send_command {
> +	__u8		opcode;
> +	__u8		resv1;
> +	__u16		command_id;
> +	__u8		fctype;
> +	__u8		resv2[19];
> +	union nvme_data_ptr dptr;
> +	__u8		resv3;
> +	__u8		spsp0;
> +	__u8		spsp1;
> +	__u8		secp;
> +	__le32		tl;
> +	__u8		resv4[12];

Isn't that 16 bytes?
You should add these to the compile time checkers
in _nvme_check_size.

> +
> +};
> +
> +struct nvmf_auth_receive_command {
> +	__u8		opcode;
> +	__u8		resv1;
> +	__u16		command_id;
> +	__u8		fctype;
> +	__u8		resv2[19];
> +	union nvme_data_ptr dptr;
> +	__u8		resv3;
> +	__u8		spsp0;
> +	__u8		spsp1;
> +	__u8		secp;
> +	__le32		al;
> +	__u8		resv4[12];
> +};
> +
> +/* Value for secp */
> +enum {
> +	NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER	= 0xe9,
> +};
> +
> +/* Defined value for auth_type */
> +enum {
> +	NVME_AUTH_COMMON_MESSAGES	= 0x00,
> +	NVME_AUTH_DHCHAP_MESSAGES	= 0x01,
> +};
> +
> +/* Defined messages for auth_id */
> +enum {
> +	NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE	= 0x00,
> +	NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE	= 0x01,
> +	NVME_AUTH_DHCHAP_MESSAGE_REPLY		= 0x02,
> +	NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1	= 0x03,
> +	NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2	= 0x04,
> +	NVME_AUTH_DHCHAP_MESSAGE_FAILURE2	= 0xf0,
> +	NVME_AUTH_DHCHAP_MESSAGE_FAILURE1	= 0xf1,
> +};
> +
> +struct nvmf_auth_dhchap_protocol_descriptor {
> +	__u8		authid;
> +	__u8		rsvd;
> +	__u8		halen;
> +	__u8		dhlen;
> +	__u8		idlist[60];
> +};
> +
> +enum {
> +	NVME_AUTH_DHCHAP_AUTH_ID	= 0x01,
> +};
> +
> +enum {
> +	NVME_AUTH_DHCHAP_HASH_SHA256	= 0x01,

Maybe s/HASH/HF/ (stands for hash function, which is
a better description).

> +	NVME_AUTH_DHCHAP_HASH_SHA384	= 0x02,
> +	NVME_AUTH_DHCHAP_HASH_SHA512	= 0x03,
> +};
> +
> +enum {
> +	NVME_AUTH_DHCHAP_DHGROUP_NULL	= 0x00,
> +	NVME_AUTH_DHCHAP_DHGROUP_2048	= 0x01,
> +	NVME_AUTH_DHCHAP_DHGROUP_3072	= 0x02,
> +	NVME_AUTH_DHCHAP_DHGROUP_4096	= 0x03,
> +	NVME_AUTH_DHCHAP_DHGROUP_6144	= 0x04,
> +	NVME_AUTH_DHCHAP_DHGROUP_8192	= 0x05,
> +};
> +
> +union nvmf_auth_protocol {
> +	struct nvmf_auth_dhchap_protocol_descriptor dhchap;
> +};
> +
> +struct nvmf_auth_dhchap_negotiate_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__u8		rsvd[2];
> +	__le16		t_id;
> +	__u8		sc_c;
> +	__u8		napd;
> +	union nvmf_auth_protocol auth_protocol[];
> +};
> +
> +struct nvmf_auth_dhchap_challenge_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__u8		rsvd1[2];
> +	__le16		t_id;
> +	__u8		hl;
> +	__u8		rsvd2;
> +	__u8		hashid;
> +	__u8		dhgid;
> +	__le16		dhvlen;
> +	__le32		seqnum;
> +	/* 'hl' bytes of challenge value */
> +	__u8		cval[];
> +	/* followed by 'dhvlen' bytes of DH value */
> +};
> +
> +struct nvmf_auth_dhchap_reply_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__u8		rsvd1[2];

Maybe __u32 rsvd1? Usually its done this way in the other
headers...

> +	__le16		t_id;
> +	__u8		hl;
> +	__u8		rsvd2;
> +	__u8		cvalid;
> +	__u8		rsvd3;
> +	__le16		dhvlen;
> +	__le32		seqnum;
> +	/* 'hl' bytes of response data */
> +	__u8		rval[];
> +	/* followed by 'hl' bytes of Challenge value */
> +	/* followed by 'dhvlen' bytes of DH value */
> +};
> +
> +enum {
> +	NVME_AUTH_DHCHAP_RESPONSE_VALID	= (1 << 0),
> +};
> +
> +struct nvmf_auth_dhchap_success1_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__u8		rsvd1[2];
> +	__le16		t_id;
> +	__u8		hl;
> +	__u8		rsvd2;
> +	__u8		rvalid;
> +	__u8		rsvd3[7];
> +	/* 'hl' bytes of response value if 'rvalid' is set */
> +	__u8		rval[];

It really sucks that we have zero-length pointers in
a wire-format struct... but anyways, it is what it is...

> +};
> +
> +struct nvmf_auth_dhchap_success2_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__u8		rsvd1[2];
> +	__le16		t_id;
> +	__u8		rsvd2[10];
> +};
> +
> +struct nvmf_auth_dhchap_failure_data {
> +	__u8		auth_type;
> +	__u8		auth_id;
> +	__u8		rsvd1[2];
> +	__le16		t_id;
> +	__u8		reason_code;
> +	__u8		reason_code_explanation;

I'd maybe do those shorter;
rescode
rescode_exp

> +};
> +
> +enum {
> +	NVME_AUTH_DHCHAP_FAILURE_REASON_FAILED	= 0x01,
> +};
> +
> +enum {
> +	NVME_AUTH_DHCHAP_FAILURE_FAILED			= 0x01,
> +	NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE		= 0x02,
> +	NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH	= 0x03,
> +	NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE		= 0x04,
> +	NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE	= 0x05,
> +	NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD	= 0x06,
> +	NVME_AUTH_DHCHAP_FAILURE_INVALID_MESSAGE	= 0x07,

I think the language in the spec is "incorrect", why not
stick with that instead of "invalid"?

> +};
> +
> +
>   struct nvme_dbbuf {
>   	__u8			opcode;
>   	__u8			flags;
> @@ -1436,6 +1617,8 @@ struct nvme_command {
>   		struct nvmf_connect_command connect;
>   		struct nvmf_property_set_command prop_set;
>   		struct nvmf_property_get_command prop_get;
> +		struct nvmf_auth_send_command auth_send;
> +		struct nvmf_auth_receive_command auth_receive;
>   		struct nvme_dbbuf dbbuf;
>   		struct nvme_directive_cmd directive;
>   	};
> 
