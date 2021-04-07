Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A91C433B4
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 05:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA64613C6
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Apr 2021 05:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348632AbhDGFU0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Apr 2021 01:20:26 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:48016 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhDGFUZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Apr 2021 01:20:25 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4FFXld5nkdz9txVX;
        Wed,  7 Apr 2021 07:20:13 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id DlNPLR3AT7kI; Wed,  7 Apr 2021 07:20:13 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FFXld2155z9txtp;
        Wed,  7 Apr 2021 07:20:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EF8CC8B781;
        Wed,  7 Apr 2021 07:20:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id DOwMAUIkrgFv; Wed,  7 Apr 2021 07:20:13 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0BB648B75F;
        Wed,  7 Apr 2021 07:20:12 +0200 (CEST)
Subject: Re: [PATCH v2 7/8] crypto: ccp: Use the stack and common buffer for
 INIT command
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-8-seanjc@google.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <29bd7f5d-ebee-b78e-8ba6-fd8e21ec1dc8@csgroup.eu>
Date:   Wed, 7 Apr 2021 07:20:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210406224952.4177376-8-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 07/04/2021 à 00:49, Sean Christopherson a écrit :
> Drop the dedicated init_cmd_buf and instead use a local variable.  Now
> that the low level helper uses an internal buffer for all commands,
> using the stack for the upper layers is safe even when running with
> CONFIG_VMAP_STACK=y.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 10 ++++++----
>   drivers/crypto/ccp/sev-dev.h |  1 -
>   2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e54774b0d637..9ff28df03030 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -233,6 +233,7 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
>   static int __sev_platform_init_locked(int *error)
>   {
>   	struct psp_device *psp = psp_master;
> +	struct sev_data_init data;

struct sev_data_init data = {0, 0, 0, 0};

>   	struct sev_device *sev;
>   	int rc = 0;
>   
> @@ -244,6 +245,7 @@ static int __sev_platform_init_locked(int *error)
>   	if (sev->state == SEV_STATE_INIT)
>   		return 0;
>   
> +	memset(&data, 0, sizeof(data));

Not needed.

>   	if (sev_es_tmr) {
>   		u64 tmr_pa;
>   
> @@ -253,12 +255,12 @@ static int __sev_platform_init_locked(int *error)
>   		 */
>   		tmr_pa = __pa(sev_es_tmr);
>   
> -		sev->init_cmd_buf.flags |= SEV_INIT_FLAGS_SEV_ES;
> -		sev->init_cmd_buf.tmr_address = tmr_pa;
> -		sev->init_cmd_buf.tmr_len = SEV_ES_TMR_SIZE;
> +		data.flags |= SEV_INIT_FLAGS_SEV_ES;
> +		data.tmr_address = tmr_pa;
> +		data.tmr_len = SEV_ES_TMR_SIZE;
>   	}
>   
> -	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &sev->init_cmd_buf, error);
> +	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
>   	if (rc)
>   		return rc;
>   
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 0fd21433f627..666c21eb81ab 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -46,7 +46,6 @@ struct sev_device {
>   	unsigned int int_rcvd;
>   	wait_queue_head_t int_queue;
>   	struct sev_misc_dev *misc;
> -	struct sev_data_init init_cmd_buf;
>   
>   	u8 api_major;
>   	u8 api_minor;
> 
