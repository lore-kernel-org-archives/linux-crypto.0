From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2 0/2] crypto: afalg_skcipher - fixes after skcipher
 conversion
Date: Thu, 28 Jan 2016 07:23:54 -0800
Message-ID: <20160128152354.5394.90834.stgit@tstruk-mobl1>
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

v2 changes:
- pass the original skcipher request in ablkcipher.base.data instead of
  casting it back from the ablkcipher request.
- rename _req to base_req
- dropped 3/3

---

Tadeusz Struk (2):
      crypto: skcipher - return the correct request to the user
      crypto: algif_skcipher - fix async callback after skcipher convertion


 crypto/algif_skcipher.c |    5 +++--
 crypto/skcipher.c       |    9 ++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)
--
