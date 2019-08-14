Return-Path: <SRS0=c3b/=WK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F64C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 13:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA7D206C2
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 13:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565789083;
	bh=728hr/u8ACkr4eN6s55og0sZZKXT3mgz/+81KVMagtM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=xu70scOONFJAxHt17l+v4aCKrlHWP54uLoJ89elGcBJ8g5c8HNJvuWUmrGaeStVvI
	 8S2ewbd/Y+jC4av0SeGItOVXl6OWpB/cUkWbDElsLN4CIYK0k8ILNQnvRtXbyu1YkD
	 qAGJf2mj/4lZYqbgzJIfAGsSTcTevCD9XK9LwjJ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfHNNYm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Aug 2019 09:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727654AbfHNNYm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Aug 2019 09:24:42 -0400
Received: from localhost.localdomain (ool-18bba523.dyn.optonline.net [24.187.165.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D46EC206C1;
        Wed, 14 Aug 2019 13:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565789081;
        bh=728hr/u8ACkr4eN6s55og0sZZKXT3mgz/+81KVMagtM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BEaIXEhbN5LobKXpsJugCZtSW+XS2aQg1QUETdq/6yY99Qn/DFfPk0cHVGWNw7TV9
         9JisrfYyNGp2YtEudUH9o6nFF5oU4tYajzzGay1/9y5T5phTGmX0XMwBVf3n9JPSXu
         hGVzpbf/flSHs0lNdtZbG0zWWST/1DLSuYP1HPPc=
Message-ID: <1565789078.10490.10.camel@kernel.org>
Subject: Re: [RFC/RFT v4 0/5] Add generic trusted keys framework/subsystem
From:   Mimi Zohar <zohar@kernel.org>
To:     Sumit Garg <sumit.garg@linaro.org>, keyrings@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, peterhuewe@gmx.de, jgg@ziepe.ca,
        jejb@linux.ibm.com, jarkko.sakkinen@linux.intel.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, jmorris@namei.org, serge@hallyn.com,
        casey@schaufler-ca.com, ard.biesheuvel@linaro.org,
        daniel.thompson@linaro.org, linux-kernel@vger.kernel.org,
        tee-dev@lists.linaro.org
Date:   Wed, 14 Aug 2019 09:24:38 -0400
In-Reply-To: <1565682784-10234-1-git-send-email-sumit.garg@linaro.org>
References: <1565682784-10234-1-git-send-email-sumit.garg@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Sumit,

On Tue, 2019-08-13 at 13:22 +0530, Sumit Garg wrote:
> This patch-set is an outcome of discussion here [1]. It has evolved very
> much since v1 to create, consolidate and generalize trusted keys
> subsystem.
> 
> This framework has been tested with trusted keys support provided via TEE
> but I wasn't able to test it with a TPM device as I don't possess one. It
> would be really helpful if others could test this patch-set using a TPM
> device.

With the "CONFIG_HEADER_TEST" and "CONFIG_KERNEL_HEADER_TEST" config
options enabled, which is required for linux-next, it fails to build.

Mimi
