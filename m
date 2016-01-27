From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/3] crypto: afalg_skcipher - fixes after skcipher conversion
Date: Wed, 27 Jan 2016 09:13:50 -0800
Message-ID: <20160127171350.32579.49931.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,
While testing the algif_aead async patch, I have rerun the async
algif_skcipher tests and I have found some problems.
There are three different issues around algif_skcipher and skcipher.
Two are skcipher conversion related, and one is a bug in the
algif_skcipher, not related to the conversion. It started to
manifest itself after a fix the the qat driver.
---

Tadeusz Struk (3):
      crypto: skcipher - return the correct request to the user
      crypto: algif_skcipher - fix async callback after skcipher convertion
      crypto: algif_skcipher - fix increase private contex space for async request


 crypto/algif_skcipher.c |   11 +++++++----
 crypto/skcipher.c       |   11 ++++++++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

--
