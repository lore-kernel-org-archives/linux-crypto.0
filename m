From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH v13 net-next 07/12] crypto: chtls - Program the TLS
 session Key
Date: Tue, 27 Mar 2018 19:41:29 +0200
Message-ID: <20180327194129.363564b4@epycfail>
References: <1522172201-7629-1-git-send-email-atul.gupta@chelsio.com>
        <1522172201-7629-8-git-send-email-atul.gupta@chelsio.com>
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
In-Reply-To: <1522172201-7629-8-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 27 Mar 2018 23:06:36 +0530
Atul Gupta <atul.gupta@chelsio.com> wrote:

> Initialize the space reserved for storing the TLS keys,
> get and free the location where key is stored for the TLS
> connection.
> Program the Tx and Rx key as received from user in
> struct tls12_crypto_info_aes_gcm_128 and understood by hardware.
> added socket option TLS_RX
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
> Reviewed-by: Sabrina Dubroca <sdubroca@redhat.com>
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Nope, sorry.

-- 
Stefano
