From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH v13 net-next 09/12] crypto: chtls - Inline TLS record Tx
Date: Tue, 27 Mar 2018 19:41:53 +0200
Message-ID: <20180327194153.78f9a2d8@epycfail>
References: <1522172201-7629-1-git-send-email-atul.gupta@chelsio.com>
        <1522172201-7629-10-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        davejwatson@fb.com, sd@queasysnail.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522172201-7629-10-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 27 Mar 2018 23:06:38 +0530
Atul Gupta <atul.gupta@chelsio.com> wrote:

> TLS handler for record transmit.
> Create Inline TLS work request and post to FW.
> Create Inline TLS record CPLs for hardware
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> Signed-off-by: Michael Werner <werner@chelsio.com>
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Absolutely not.

-- 
Stefano
