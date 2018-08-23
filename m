From: Petr Vorel <pvorel@suse.cz>
Subject: Backport e666d4e9ceec crypto: vmx - Use skcipher for ctr fallback
Date: Thu, 23 Aug 2018 17:31:01 +0200
Message-ID: <20180823153101.GA27143@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I wonder, it it makes sense to backport commit
e666d4e9ceec crypto: vmx - Use skcipher for ctr fallback
to v 4.14 stable kernel.
I'm using it in 4.12+.

These commits (somehow similar) has been backported to 4.10.2:
5839f555fa57 crypto: vmx - Use skcipher for xts fallback
c96d0a1c47ab crypto: vmx - Use skcipher for cbc fallback

Kind regards,
Petr
