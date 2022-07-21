Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AF7C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 11:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiGULJt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 07:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbiGULJt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 07:09:49 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76C182FB3
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 04:09:47 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-118-63.bstnma.fios.verizon.net [173.48.118.63])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 26LB9WBf007214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 07:09:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1658401774; bh=GPkbqZ/O/IvLwm8cIuqF18sJFHwzYTt7nnB/X0vZ+n0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=L08mKA//gc+496O/T0yrN5LvKuWe4N2ezMJBUnSj3izz5RXRwEXH+9g6Qyffu3jk4
         DAKwd6dYqikULAqkUnryKf7RdFBlzCsdxlNDoSYNZ8OXmAv+fzg2Lu8jim2mHlYkyj
         Z/vt4X33A3OR9kKSq7Q53xKGtpboko9wnl5AWRiPfL5iQmFwJoFOZ3iDaMzRlrAhjD
         7+CvJtyCNESaMHNp4/pSzWQxeKWlsYaPBT0Zovnye86/yOnE90VPoqPdeyIghQVy4i
         S+NmbE5scAciSduD4o1rstA8co8sZlyKx16sNSPgmHnGO+VkjRwA4mQeaa9le+R+bx
         oXp5K+lRHN4Bw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 850EE15C3EBF; Thu, 21 Jul 2022 07:09:32 -0400 (EDT)
Date:   Thu, 21 Jul 2022 07:09:32 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, luto@kernel.org
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Message-ID: <Ytkz7DOfL6mFCxnI@mit.edu>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <YtaPJPkewin5uWdn@zx2c4.com>
 <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain>
 <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 21, 2022 at 02:44:54PM +0800, Guozihua (Scott) wrote:
 > 
> We have a userspace program that starts pretty early in the boot process and
> it tries to fetch random bits from /dev/random with O_NONBLOCK, if that
> returns -EAGAIN, it turns to /dev/urandom. Is this a correct handling of
> -EAGAIN? Or this is not one of the intended use case of O_NONBLOCK?

In addition to the good points which Eric and Jason have raised, the
other thing I would ask you is ***why*** is your userspace program
trying to fetch random bits early in the boot process?  Is it, say,
trying to generate a cryptographic key which is security critical.  If
so, then DON'T DO THAT.

There have been plenty of really embarrassing security problems caused
by consumer grade products who generate a public/private key pair
within seconds of the customer taking the product out of the box, and
plugging it into the wall for the first time.  At which point,
hilarity ensues, unless the box is life- or mission- critical, in
which case tragedy ensues....

Is it possible to move the userspace program so it's not being started
early in the boot process?  What is it doing, and why does it need
random data in the first place?

						- Ted
