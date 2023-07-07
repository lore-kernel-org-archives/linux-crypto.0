Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF3BEB64D9
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jul 2023 10:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjGGKmI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jul 2023 06:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGGKmI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2023 06:42:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17F81737
        for <linux-crypto@vger.kernel.org>; Fri,  7 Jul 2023 03:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688726485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k2/vCgILvmVJSsmBnlxcM6iJxhHNGN00w3k9umPrbhE=;
        b=CoKcEfzdE5EnLrbR6oQYifhwf+d3cHEC4cNWKQFZMA7QTGZNYLu/yWrqxXonBFpTSPpbuH
        qsiERoKU0h93AnYthXnH9SsA9RvZ32/57UNAQulTM4M04SRU+nPIlDEPYEHiMQVw2CxhZn
        7LeZLuOUp8+1MPQwWvkKgnYH5zGpVvE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-_-BNR3qjO8ycyI6cBa31ZQ-1; Fri, 07 Jul 2023 06:41:20 -0400
X-MC-Unique: _-BNR3qjO8ycyI6cBa31ZQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 395B63C0F68E;
        Fri,  7 Jul 2023 10:41:19 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F4B6F640B;
        Fri,  7 Jul 2023 10:41:19 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
        id 0A67530C0457; Fri,  7 Jul 2023 10:41:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 06C5A3FB76;
        Fri,  7 Jul 2023 12:41:19 +0200 (CEST)
Date:   Fri, 7 Jul 2023 12:41:19 +0200 (CEST)
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        herbert@gondor.apana.org.au, horia.geanta@nxp.com,
        pankaj.gupta@nxp.com, gaurav.jain@nxp.com, heinzm@redhat.com,
        snitzer@kernel.org, linux-kernel@vger.kernel.org,
        qat-linux@intel.com, iuliana.prodan@nxp.com, dm-devel@redhat.com,
        meenakshi.aggarwal@nxp.com, linux-crypto@vger.kernel.org,
        davem@davemloft.net, agk@redhat.com, V.Sethi@nxp.com
Subject: Re: [dm-devel] [PATCH 2/3] crypto: api - adjust meaning of
 CRYPTO_ALG_ALLOCATES_MEMORY
In-Reply-To: <20230705201812.GB866@sol.localdomain>
Message-ID: <daf1c4c8-292f-4954-9bde-b6d891a832dc@redhat.com>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com> <20230705164009.58351-3-giovanni.cabiddu@intel.com> <20230705201812.GB866@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Wed, 5 Jul 2023, Eric Biggers wrote:

> On Wed, Jul 05, 2023 at 05:40:08PM +0100, Giovanni Cabiddu wrote:
> 
> > Algorithms that do not set this flag will guarantee
> 
> "will guarantee" => "guarantee"
>  
> > that memory is not allocated during request processing, except in
> > the avoidable exception cases described below.
> 
> "avoidable exception cases" => "exception cases"
> 
> Whether they are avoidable depends on the user.
> 
> > * Users can request an algorithm with this flag unset if they can't handle
> > * memory allocation failures or sleeping during request processing.
> 
> Why add the "sleeping during request processing" part?  Isn't that controlled on
> a per-request basis by CRYPTO_TFM_REQ_MAY_SLEEP which is a separate thing?
> 
> > * They should also follow the constraints below.
> 
> "should" => "must"
> 
> > + *	- The input and output scatterlists must have no more than 4 entries.
> > + *	  If the scatterlists contain more than 4 entries, the algorithm may
> > + *	  allocate memory.
> 
> "If the scatterlists contains" => "If either scatterlist contains"
> 
> Otherwise it is unclear whether this is talking about the length of each
> scatterlist individually, or the sum of their lengths.
> 
> - Eric

Hi

I wouldn't change the meaning of CRYPTO_ALG_ALLOCATES_MEMORY (because 
people will forget about this subtle change anyway).

Also note that dm-integrity allocates arbitrarily large sg-lists when 
encrypting the journal, so if you change the meaning of 
CRYPTO_ALG_ALLOCATES_MEMORY, there would be no flag left for dm-integrity 
to test.

I would introduce a new flag, something like 
CRYPTO_ALG_ALLOCATES_MEMORY_FOR_5_OR_MORE_SG_ENTRIES. dm-crypt can then 
filter the algorithms based on this flag - and the rest of the kernel code 
may stay unchanged.

Mikulas

