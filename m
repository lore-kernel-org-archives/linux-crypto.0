Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E597CC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 12:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbiCVMqG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 08:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiCVMqF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 08:46:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DF61DA56
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 05:44:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1532B210F3;
        Tue, 22 Mar 2022 12:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647953076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=66C1Tt60lTc2dTAFcxf1X3iml+8FNPPGH0Qyxe2exkM=;
        b=m4C/gOsMBBnj5U7SD+3qeaHORCCSvGe5MKOq3rdx+ohqp1dIMEcpZeiHrgZPmq2rZZKZMW
        lWIFdfioQq6AV2fUjcthrWLywR44oL8krxzFsA70211wfxZ9A1xtL6lDRw50BrmVL883QF
        DTmEFNm6Xz+sTLyuA3wI6xfijHxanlc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647953076;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=66C1Tt60lTc2dTAFcxf1X3iml+8FNPPGH0Qyxe2exkM=;
        b=5O1rlcfNil8Ak4Qfk+aZgCzmVnyLAbw3Qbf7NveAxg+37znAA85TxmoprPREG1aViF7ve4
        z1ZHIF5V6qp5t7Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0465912FC5;
        Tue, 22 Mar 2022 12:44:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cODWALTEOWKecAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 22 Mar 2022 12:44:36 +0000
Message-ID: <d7689bfa-787c-8ece-1b87-d147ad5e3ed2@suse.de>
Date:   Tue, 22 Mar 2022 13:44:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
References: <20211202152358.60116-1-hare@suse.de>
 <20211202152358.60116-8-hare@suse.de>
 <346e03e9-ece1-73f9-f7f4-c987055c5b9f@nvidia.com>
 <3382242d-7349-e6f9-9b3c-4a5162f630c0@suse.de>
 <4f320d3b-7ade-211c-e1ff-d4eb37fe540a@nvidia.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/12] nvme: Implement In-Band authentication
In-Reply-To: <4f320d3b-7ade-211c-e1ff-d4eb37fe540a@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/22/22 13:21, Max Gurtovoy wrote:
> 
> On 3/22/2022 2:10 PM, Hannes Reinecke wrote:
>> On 3/22/22 12:40, Max Gurtovoy wrote:
>>> Hi Hannes,
>>>
>>> On 12/2/2021 5:23 PM, Hannes Reinecke wrote:
>>>> Implement NVMe-oF In-Band authentication according to NVMe TPAR 8006.
>>>> This patch adds two new fabric options 'dhchap_secret' to specify the
>>>> pre-shared key (in ASCII respresentation according to NVMe 2.0 section
>>>> 8.13.5.8 'Secret representation') and 'dhchap_ctrl_secret' to specify
>>>> the pre-shared controller key for bi-directional authentication of both
>>>> the host and the controller.
>>>> Re-authentication can be triggered by writing the PSK into the new
>>>> controller sysfs attribute 'dhchap_secret' or 'dhchap_ctrl_secret'.
>>>
>>> Can you please add to commit log an example of the process ?
>>>
>>>  From target configuration through the 'nvme connect' cmd.
>>>
>>>
>>
>> Please check:
>>
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fhreinecke%2Fblktests%2Ftree%2Fauth.v3&amp;data=04%7C01%7Cmgurtovoy%40nvidia.com%7C4e6a16198c834c87e2ac08da0bfd01fc%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637835478535167965%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=OgZkPCwDUIllRWfKF0SoC6osWJy3hqAZouME3KDnIGQ%3D&amp;reserved=0 
>>
>>
>> That contains the blktest scripts I'm using to validate the 
>> implementation.
>>
> blktest is great but for features in this magnitude I think we need to 
> add a simple usage example in the commit log or in the cover letter.
> 
> for someone that is not familiar with blktests, one should start reverse 
> engineering 4000 LOC to use it.
> 

Right.
Essentially it boils down to this:

nvme gen-dhchap-key > host_key.txt
nvme gen-dhchap-key > target_key.txt
mkdir /sys/kernel/config/nvmet/hosts/<hostnqn>
cd /sys/kernel/config/nvmet/hosts/<hostnqn>
cat host_key.txt > dhchap_key
cat target_key.txt > dhchap_ctrl_key
<link 'hostnqn' to the target subsystem>

And then one the host you need to call

'nvme connect ... --dhchap-key=$(cat host_key)'

And things should work.

But I can put a more detailed description in the commit log.

Note, I'm waiting for Herbert Xu to merge his 'cryptodev' tree with 
upstream; once that's done I'll be submitting these patches.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
