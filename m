From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/6] crypto: engine - Permit to enqueue all async
 requests
Date: Sat, 17 Feb 2018 12:42:26 +0800
Message-ID: <20180217044226.GA12701@gondor.apana.org.au>
References: <20180126191534.17569-1-clabbe.montjoie@gmail.com>
 <20180215155100.GJ7352@gondor.apana.org.au>
 <20180216153656.GA22492@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexandre.torgue@st.com, arei.gonglei@huawei.com, corbet@lwn.net,
        davem@davemloft.net, jasowang@redhat.com,
        mcoquelin.stm32@gmail.com, mst@redhat.com, fabien.dessenne@st.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-sunxi@googlegroups.com
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:43816 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeBQEmv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Feb 2018 23:42:51 -0500
Content-Disposition: inline
In-Reply-To: <20180216153656.GA22492@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 16, 2018 at 04:36:56PM +0100, Corentin Labbe wrote:
>
> As mentionned in the cover letter, all patchs (except documentation one) should be squashed.
> A kbuild robot reported a build error on cryptodev due to this.

It's too late now.  In future if you want the patches to be squashed
then please send them in one email.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
