Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39F5C10F27
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 14:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA0B208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 14:45:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WbfnQBbj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgCJOpd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 10:45:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59852 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726469AbgCJOpd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 10:45:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583851532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QTD9afnjqEF/c/isdcMhPQWefEQroVBPT+wqW9gBjhw=;
        b=WbfnQBbjk2KMCyd1s/zILYM7AiUje2TBp3x4h/pSneLjwXZDqW85QcmkeMG+3Pm2/HItne
        cmifDrwYH42GpuQtORvIh0KpPqgf/xGZT7IkOuxEjWMBU7vI7FVLh6PY8cx18X3W5pd27d
        akgtitmqP6r8kS2XKy/C+d0fWWHPTqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-hLLACgEHNFmbutQd2CrKqg-1; Tue, 10 Mar 2020 10:45:30 -0400
X-MC-Unique: hLLACgEHNFmbutQd2CrKqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC2BF85EE83;
        Tue, 10 Mar 2020 14:45:28 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD2CE92D20;
        Tue, 10 Mar 2020 14:45:24 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        gary.hook@amd.com, erdemaktas@google.com, rientjes@google.com,
        npmccallum@redhat.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: ccp: use file mode for sev ioctl permissions
References: <20200306172010.1213899-1-ckuehl@redhat.com>
        <20200306172010.1213899-2-ckuehl@redhat.com>
        <b037d70f-c23f-72d6-3866-57cb1e501eba@amd.com>
Date:   Tue, 10 Mar 2020 10:45:24 -0400
In-Reply-To: <b037d70f-c23f-72d6-3866-57cb1e501eba@amd.com> (Brijesh Singh's
        message of "Tue, 10 Mar 2020 09:37:21 -0500")
Message-ID: <jpgpndkjmkb.fsf@linux.bootlegged.copy>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Brijesh Singh <brijesh.singh@amd.com> writes:

> On 3/6/20 11:20 AM, Connor Kuehl wrote:
>> Instead of using CAP_SYS_ADMIN which is restricted to the root user,
>> check the file mode for write permissions before executing commands that
>> can affect the platform. This allows for more fine-grained access
>> control to the SEV ioctl interface. This would allow a SEV-only user
>> or group the ability to administer the platform without requiring them
>> to be root or granting them overly powerful permissions.
>>
>> For example:
>>
>> chown root:root /dev/sev
>> chmod 600 /dev/sev
>> setfacl -m g:sev:r /dev/sev
>> setfacl -m g:sev-admin:rw /dev/sev
>>
>> In this instance, members of the "sev-admin" group have the ability to
>> perform all ioctl calls (including the ones that modify platform state).
>> Members of the "sev" group only have access to the ioctls that do not
>> modify the platform state.
>>
>> This also makes opening "/dev/sev" more consistent with how file
>> descriptors are usually handled. By only checking for CAP_SYS_ADMIN,
>> the file descriptor could be opened read-only but could still execute
>> ioctls that modify the platform state. This patch enforces that the file
>> descriptor is opened with write privileges if it is going to be used to
>> modify the platform state.
>>
>> This flexibility is completely opt-in, and if it is not desirable by
>> the administrator then they do not need to give anyone else access to
>> /dev/sev.
>>
>> Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++----------------
>>   1 file changed, 17 insertions(+), 16 deletions(-)
>>
>
> Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
>
> thanks

Reviewed-by: Bandan Das <bsd@redhat.com>

