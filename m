Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3E1C432BE
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 19:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A39360E78
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 19:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhH0TwK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Aug 2021 15:52:10 -0400
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:53076 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229821AbhH0TwJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Aug 2021 15:52:09 -0400
X-Greylist: delayed 1057 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2021 15:52:09 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id 450631814F43A
        for <linux-crypto@vger.kernel.org>; Fri, 27 Aug 2021 19:33:45 +0000 (UTC)
Received: from omf08.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 345D31814EE9B;
        Fri, 27 Aug 2021 19:33:42 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id 1234C1A29FC;
        Fri, 27 Aug 2021 19:33:40 +0000 (UTC)
Message-ID: <e25f996113e08e37dbfbc3c8ef985ce9423e710f.camel@perches.com>
Subject: Re: crypto: hisilicon - Fix sscanf format signedness
From:   Joe Perches <joe@perches.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>
Cc:     Kai Ye <yekai13@huawei.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Date:   Fri, 27 Aug 2021 12:33:39 -0700
In-Reply-To: <20210827084310.GA21801@gondor.apana.org.au>
References: <202108220901.8r4gf0hB-lkp@intel.com>
         <20210827084310.GA21801@gondor.apana.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 1234C1A29FC
X-Stat-Signature: xneszf1qkphk8kssryz9ngoogkc9dhwx
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18ke7j3yrhfoFJYnJpufT9DxU+0WKPX+hs=
X-HE-Tag: 1630092820-89614
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2021-08-27 at 16:43 +0800, Herbert Xu wrote:
> The function qm_qos_value_init expects an unsigned integer but
> is incorrectly supplying a signed format to sscanf.  This patch
> fixes it.
[]
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
[]
> @@ -4191,7 +4191,7 @@ static ssize_t qm_qos_value_init(const char *buf, unsigned long *val)
>  			return -EINVAL;
>  	}
>  
> 
> -	ret = sscanf(buf, "%ld", val);
> +	ret = sscanf(buf, "%lu", val);
>  	if (ret != QM_QOS_VAL_NUM)
>  		return -EINVAL;

QM_QOS_VAL_NUM seems an especially silly define

A direct use of 1 would be _far_ better IMO.

$ git grep -w -n QM_QOS_VAL_NUM
drivers/crypto/hisilicon/qm.c:246:#define QM_QOS_VAL_NUM                        1
drivers/crypto/hisilicon/qm.c:4189:     if (ret != QM_QOS_VAL_NUM)


