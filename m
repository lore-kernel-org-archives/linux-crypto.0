Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA99E9413E
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Oct 2023 02:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbjJGC4q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Oct 2023 22:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjJGC4p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2023 22:56:45 -0400
Received: from wxsgout04.xfusion.com (wxsgout03.xfusion.com [36.139.52.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FC9BD;
        Fri,  6 Oct 2023 19:56:43 -0700 (PDT)
Received: from wuxshcsitd00600.xfusion.com (unknown [10.32.133.213])
        by wxsgout04.xfusion.com (SkyGuard) with ESMTPS id 4S2VHx3hHZzB0SM8;
        Sat,  7 Oct 2023 10:54:21 +0800 (CST)
Received: from localhost (10.82.147.3) by wuxshcsitd00600.xfusion.com
 (10.32.133.213) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sat, 7 Oct
 2023 10:56:31 +0800
Date:   Sat, 7 Oct 2023 10:56:31 +0800
From:   Wang Jinchao <wangjinchao@xfusion.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stone.xulei@xfusion.com>
Subject: Re: Issue: Can padata avoid dealing with CPU-related operations?
Message-ID: <ZSDI34RMdJ7es7hj@fedora>
References: <ZRQtYnAhF2byr784@fedora>
 <cwcbhk22vycf6di4d5x56l2e5sxm2o5s45v4w6abqggyluyzko@xhcveoev3vhu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cwcbhk22vycf6di4d5x56l2e5sxm2o5s45v4w6abqggyluyzko@xhcveoev3vhu>
X-Originating-IP: [10.82.147.3]
X-ClientProxiedBy: wuxshcsitd00601.xfusion.com (10.32.135.241) To
 wuxshcsitd00600.xfusion.com (10.32.133.213)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 04, 2023 at 10:52:57AM -0400, Daniel Jordan wrote:
> Hi,
> 
> On Wed, Sep 27, 2023 at 09:25:54PM +0800, Wang Jinchao wrote:
> > Hello, I have a few questions about the padata code I've been studying
> > recently:
> > 
> > - Why does padata use the WQ_UNBOUND attribute of the workqueue?
> 
> There's background in this series:
>     https://lore.kernel.org/all/20190813005224.30779-1-daniel.m.jordan@oracle.com/
> 
Summarizing, the use of the WQ_UNBOUND attribute is primarily based on performance
considerations. Is this understanding correct?
> > Because I've noticed a significant maintenance cost related to CPUs.
> > Are there any specific benefits?
> 
> Aside from what Steffen said about serialization, the pcrypt cpumasks
> can be set from sysfs to control where parallel and serial jobs run.
> 
> > - In what scenarios is it necessary to specify a CPU for serial
> > execution, or is ensuring the order sufficient?
> 
> I'm not sure that it's necessary.  The way I read it, at least, it seems
> pcrypt uses cb_cpu to load balance serialization across all CPUs allowed
> in the serial cpumask.

I recognize that the key issue isn't the capabilities it can offer, but rather
the underlying necessity for these capabilities. If the need isn't particularly
strong and the cost of implementing this capability is high, should we consider
omitting it?

As previously mentioned in another email, I'm seeking guidance on how to effectively 
evaluate the timing of padata serialization in a network environment. 
Could you provide some insights or pointers on this matter?

Furthermore, I'd like to extend my sincere gratitude for your recent responses 
and would appreciate discussing my future steps with you. 
Thank you.
