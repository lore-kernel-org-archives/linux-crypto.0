Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C900BCCA48D
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 20:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbiGYUja (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 16:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237214AbiGYUj3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 16:39:29 -0400
X-Greylist: delayed 474 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Jul 2022 13:39:28 PDT
Received: from zimbra.cs.ucla.edu (zimbra.cs.ucla.edu [131.179.128.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1116922BF0
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 13:39:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.cs.ucla.edu (Postfix) with ESMTP id E276F160051;
        Mon, 25 Jul 2022 13:31:33 -0700 (PDT)
Received: from zimbra.cs.ucla.edu ([127.0.0.1])
        by localhost (zimbra.cs.ucla.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id hEt1VM_rxK-b; Mon, 25 Jul 2022 13:31:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.cs.ucla.edu (Postfix) with ESMTP id 3C14C16005C;
        Mon, 25 Jul 2022 13:31:33 -0700 (PDT)
X-Virus-Scanned: amavisd-new at zimbra.cs.ucla.edu
Received: from zimbra.cs.ucla.edu ([127.0.0.1])
        by localhost (zimbra.cs.ucla.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7Fvocodj1riJ; Mon, 25 Jul 2022 13:31:33 -0700 (PDT)
Received: from [192.168.1.9] (cpe-172-91-119-151.socal.res.rr.com [172.91.119.151])
        by zimbra.cs.ucla.edu (Postfix) with ESMTPSA id 0F202160051;
        Mon, 25 Jul 2022 13:31:33 -0700 (PDT)
Message-ID: <5c29df04-6283-9eee-6648-215b52cfa26b@cs.ucla.edu>
Date:   Mon, 25 Jul 2022 13:31:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org, linux-crypto@vger.kernel.org
References: <Ytwg8YEJn+76h5g9@zx2c4.com>
 <555f2208-6a04-8c3c-ea52-41ad02b33b0c@cs.ucla.edu>
 <Yt3b/HOguK9NFgCd@zx2c4.com>
From:   Paul Eggert <eggert@cs.ucla.edu>
Organization: UCLA Computer Science Department
Subject: Re: arc4random - are you sure we want these?
In-Reply-To: <Yt3b/HOguK9NFgCd@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/24/22 16:55, Jason A. Donenfeld wrote:

> Sorry I missed your reply earlier. I'm not a subscriber so I missed this
> as I somehow fell out of the CC.

Your email provider (Google) rejected email from cs.ucla.edu on the 
grounds that its IP address 131.179.128.68 has a "very low reputation". 
Google provided no way to appeal or fix the problem.

I am using "Reply All" for this message because Google likely won't 
deliver it to you directly. Perhaps someone else can forward it to you 
for me. (Sorry to bother the list.)

Perhaps this is a subtle way to encourage our department's faculty to 
let Google manage our email. We've resisted so far, though.
