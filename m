From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] padata: Remove unused but set variables
Date: Fri, 21 Oct 2016 11:00:47 +0200
Message-ID: <20161021090047.GO19080@gauss.secunet.com>
References: <20161017101608.18007-1-tklauser@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Tobias Klauser <tklauser@distanz.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:50961 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932090AbcJUJA5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2016 05:00:57 -0400
Content-Disposition: inline
In-Reply-To: <20161017101608.18007-1-tklauser@distanz.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 17, 2016 at 12:16:08PM +0200, Tobias Klauser wrote:
> Remove the unused but set variable pinst in padata_parallel_worker to
> fix the following warning when building with 'W=1':
> 
>   kernel/padata.c: In function ‘padata_parallel_worker’:
>   kernel/padata.c:68:26: warning: variable ‘pinst’ set but not used [-Wunused-but-set-variable]
> 
> Also remove the now unused variable pd which is only used to set pinst.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks!
