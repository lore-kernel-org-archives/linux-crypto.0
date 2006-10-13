From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
Subject: [FYI]: Introduction of the support for RFC4312(The Camellia Cipher
 Algorithm)
Date: Fri, 13 Oct 2006 14:36:08 +0900 (JST)
Message-ID: <20061013.143608.304095551.takamiya@po.ntts.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: takamiya@po.ntts.co.jp, netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
To: linux-crypto@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

  This is Takamiya, from NTT Software.

  NTT has released the code of the new cipher algorithm, which is
  specified in RFC4312(The Camellia Cipher Algorithm)

  Please see
  http://info.isl.ntt.co.jp/crypt/eng/camellia/source_s.html .

  The above patch is available for the version of 2.6.18.

  We started to prepare the patch against the cryptodev-2.6 tree, and
  will submit it in the few weeks.

  Best regards.

P.S.
  The patches to use camellia algorithm from ipsec-tools is also
  available on the above URL, and it will be merged into the
  ipsec-tools, too.

-- 
Noriaki TAKAMIYA
