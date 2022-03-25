Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478CBC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Mar 2022 01:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357612AbiCYBrk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355124AbiCYBri (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Mar 2022 21:47:38 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBEF5418E
        for <linux-crypto@vger.kernel.org>; Thu, 24 Mar 2022 18:46:01 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 22P1jugn025011
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 21:45:57 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id D25F515C0038; Thu, 24 Mar 2022 21:45:56 -0400 (EDT)
Date:   Thu, 24 Mar 2022 21:45:56 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: Entropy as a Service?
Message-ID: <Yj0e1MOaneLNMHim@mit.edu>
References: <CACXcFm=UTJ_wJL0w4=4kD5xcN+n-oi_4zmaxQqPunQGsPqhO1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFm=UTJ_wJL0w4=4kD5xcN+n-oi_4zmaxQqPunQGsPqhO1g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 24, 2022 at 02:10:26PM +0800, Sandy Harris wrote:
> NIST have a project called Entropy as a Service; the main goal seems
> to be to provide adequate entropy even on IoT devices which may have
> various limitations.
> https://csrc.nist.gov/projects/entropy-as-a-service
> 
> I have not yet looked at all the details but -- since Linux runs on
> many IoT devices and on some of them random(4) encounters difficulties
> -- I wonder to what extent this might be relevant for Linux.

There is more detail about the proposal here:

   https://csrc.nist.gov/Projects/Entropy-as-a-Service/Architectures

My initial reactions:

1) This is not a matter for the kernel, but for userspace to
implement, since it involves multiple HTTP (yes, really, HTTP, not
HTTPS) and NTP exchanges --- the crypto is done explicitly since
presumably the designers didn't want to assume the IOT has a comment
and bug-free(tm) implementation of HTTPS.  Probably a good idea....

2) The scheme only works if you assume that there is no collusion
between the operators of the various remote servers used in the
protocol.

3)  NIST recognizes this, and has the following warning:

   WARNING:The resulting from Step 6 of the protocol random data shall
   not be used directly for constructing cryptographic keys with it or
   as a seed to a DRBG. Instead, known cryptographic mechanisms for
   combining multiple random data sources shall be used to mix random
   data obtained from multiple remote EaaS instances with local, with
   respect to the client system and the HRT device, randomness to
   create a seed for a NIST approved DRBG. Such cryptographic
   mechanisms are known in the trade as entropy/randomness extraction.

   It is strongly recommended at a minimum two independent EaaS
   instances located in different geopolitical locales be used as
   remote sources....

My conclusion is that it's not snake oil, but it's not a magic bullet,
either.  TNSTAAFL.

						- Ted
							
