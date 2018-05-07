From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] crypto: chtls - fix a missing-check bug
Date: Mon, 7 May 2018 13:39:54 +0300
Message-ID: <20180507103954.d3gfgyjnce2ctp4p@mwanda>
References: <1525546431-12535-1-git-send-email-wang6495@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Casey Leedom <leedom@chelsio.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Wenwen Wang <wang6495@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
 open list <linux-kernel@vger.kernel.org>, Harsh Jain <harsh@chelsio.com>,
 Atul Gupta <atul.gupta@chelsio.com>, kbuild-all@01.org,
 Michael Werner <werner@chelsio.com>, "David S. Miller" <davem@davemloft.net>,
 "open list:CXGB4 CRYPTO DRIVER \(chcr\)" <linux-crypto@vger.kernel.org>
To: kbuild@01.org, Wenwen Wang <wang6495@umn.edu>
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <1525546431-12535-1-git-send-email-wang6495@umn.edu>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
List-Id: linux-crypto.vger.kernel.org

Hi Wenwen,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cryptodev/master]
[also build test WARNING on v4.17-rc3 next-20180504]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Wenwen-Wang/crypto-chtls-fix-a-missing-check-bug/20180506-091039
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
:::::: branch date: 26 hours ago
:::::: commit date: 26 hours ago

New smatch warnings:
drivers/crypto/chelsio/chtls/chtls_main.c:496 do_chtls_setsockopt() warn: potential pointer math issue ('crypto_info' is a 32 bit pointer)

Old smatch warnings:
drivers/crypto/chelsio/chtls/chtls_main.c:253 chtls_uld_add() error: buffer overflow 'cdev->rspq_skb_cache' 32 <= 32
drivers/crypto/chelsio/chtls/chtls_main.c:350 chtls_recv_packet() error: double free of 'skb'
drivers/crypto/chelsio/chtls/chtls_main.c:390 chtls_recv_rsp() error: double free of 'skb'
drivers/crypto/chelsio/chtls/chtls_main.c:408 chtls_recv() error: double free of 'skb'

# https://github.com/0day-ci/linux/commit/183b5e3e71c75e3149dac2698883f0bd63a89c75
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 183b5e3e71c75e3149dac2698883f0bd63a89c75
vim +496 drivers/crypto/chelsio/chtls/chtls_main.c

a0894394 Atul Gupta  2018-03-31  461  
a0894394 Atul Gupta  2018-03-31  462  static int do_chtls_setsockopt(struct sock *sk, int optname,
a0894394 Atul Gupta  2018-03-31  463  			       char __user *optval, unsigned int optlen)
a0894394 Atul Gupta  2018-03-31  464  {
a0894394 Atul Gupta  2018-03-31  465  	struct tls_crypto_info *crypto_info, tmp_crypto_info;
a0894394 Atul Gupta  2018-03-31  466  	struct chtls_sock *csk;
a0894394 Atul Gupta  2018-03-31  467  	int keylen;
a0894394 Atul Gupta  2018-03-31  468  	int rc = 0;
a0894394 Atul Gupta  2018-03-31  469  
a0894394 Atul Gupta  2018-03-31  470  	csk = rcu_dereference_sk_user_data(sk);
a0894394 Atul Gupta  2018-03-31  471  
a0894394 Atul Gupta  2018-03-31  472  	if (!optval || optlen < sizeof(*crypto_info)) {
a0894394 Atul Gupta  2018-03-31  473  		rc = -EINVAL;
a0894394 Atul Gupta  2018-03-31  474  		goto out;
a0894394 Atul Gupta  2018-03-31  475  	}
a0894394 Atul Gupta  2018-03-31  476  
a0894394 Atul Gupta  2018-03-31  477  	rc = copy_from_user(&tmp_crypto_info, optval, sizeof(*crypto_info));
a0894394 Atul Gupta  2018-03-31  478  	if (rc) {
a0894394 Atul Gupta  2018-03-31  479  		rc = -EFAULT;
a0894394 Atul Gupta  2018-03-31  480  		goto out;
a0894394 Atul Gupta  2018-03-31  481  	}
a0894394 Atul Gupta  2018-03-31  482  
a0894394 Atul Gupta  2018-03-31  483  	/* check version */
a0894394 Atul Gupta  2018-03-31  484  	if (tmp_crypto_info.version != TLS_1_2_VERSION) {
a0894394 Atul Gupta  2018-03-31  485  		rc = -ENOTSUPP;
a0894394 Atul Gupta  2018-03-31  486  		goto out;
a0894394 Atul Gupta  2018-03-31  487  	}
a0894394 Atul Gupta  2018-03-31  488  
a0894394 Atul Gupta  2018-03-31  489  	crypto_info = (struct tls_crypto_info *)&csk->tlshws.crypto_info;
a0894394 Atul Gupta  2018-03-31  490  
a0894394 Atul Gupta  2018-03-31  491  	switch (tmp_crypto_info.cipher_type) {
a0894394 Atul Gupta  2018-03-31  492  	case TLS_CIPHER_AES_GCM_128: {
183b5e3e Wenwen Wang 2018-05-05  493  		/* Obtain version and type from previous copy */
183b5e3e Wenwen Wang 2018-05-05  494  		crypto_info[0] = tmp_crypto_info;
183b5e3e Wenwen Wang 2018-05-05  495  		/* Now copy the following data */
183b5e3e Wenwen Wang 2018-05-05 @496  		rc = copy_from_user(crypto_info + sizeof(*crypto_info),
183b5e3e Wenwen Wang 2018-05-05  497  				optval + sizeof(*crypto_info),
183b5e3e Wenwen Wang 2018-05-05  498  				sizeof(struct tls12_crypto_info_aes_gcm_128)
183b5e3e Wenwen Wang 2018-05-05  499  				- sizeof(*crypto_info));
a0894394 Atul Gupta  2018-03-31  500  
a0894394 Atul Gupta  2018-03-31  501  		if (rc) {
a0894394 Atul Gupta  2018-03-31  502  			rc = -EFAULT;
a0894394 Atul Gupta  2018-03-31  503  			goto out;
a0894394 Atul Gupta  2018-03-31  504  		}
a0894394 Atul Gupta  2018-03-31  505  
a0894394 Atul Gupta  2018-03-31  506  		keylen = TLS_CIPHER_AES_GCM_128_KEY_SIZE;
a0894394 Atul Gupta  2018-03-31  507  		rc = chtls_setkey(csk, keylen, optname);
a0894394 Atul Gupta  2018-03-31  508  		break;
a0894394 Atul Gupta  2018-03-31  509  	}
a0894394 Atul Gupta  2018-03-31  510  	default:
a0894394 Atul Gupta  2018-03-31  511  		rc = -EINVAL;
a0894394 Atul Gupta  2018-03-31  512  		goto out;
a0894394 Atul Gupta  2018-03-31  513  	}
a0894394 Atul Gupta  2018-03-31  514  out:
a0894394 Atul Gupta  2018-03-31  515  	return rc;
a0894394 Atul Gupta  2018-03-31  516  }
a0894394 Atul Gupta  2018-03-31  517  
