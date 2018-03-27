From: Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH v13 net-next 02/12] ethtool: enable Inline TLS in HW
Date: Tue, 27 Mar 2018 22:44:20 +0200
Message-ID: <20180327204420.GA18933@bistromath.localdomain>
References: <1522172201-7629-1-git-send-email-atul.gupta@chelsio.com>
 <1522172201-7629-3-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        davejwatson@fb.com, sbrivio@redhat.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522172201-7629-3-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

2018-03-27, 23:06:31 +0530, Atul Gupta wrote:
> Ethtool option enables TLS record offload on HW, user
> configures the feature for netdev capable of Inline TLS.
> This allows user to define custom sk_prot for Inline TLS sock
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> Reviewed-by: Sabrina Dubroca <sdubroca@redhat.com>

uh, what? I definitely didn't give my "Reviewed-by" for any of these
patches. Please never do that again.

-- 
Sabrina
